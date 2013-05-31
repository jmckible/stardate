class Account < ActiveRecord::Base
  include Taggable

  belongs_to :deferral, class_name: 'Account'
  belongs_to :household

  has_many :credits, class_name: 'Transaction', foreign_key: 'credit_id'
  has_many :debits,  class_name: 'Transaction', foreign_key: 'debit_id'

  def transactions
    household.transactions.where('debit_id = ? OR credit_id = ?', id, id)
  end

  scope :asset,     where(asset: true)
  scope :cash,      where(asset: true, general: true)
  scope :dashboard, where(dashboard: true)
  scope :equity,    where(equity: true)
  scope :except,    lambda{|account| where('accounts.id != ?', account.id)}
  scope :expense,   where(expense: true)
  scope :general_income, where(income: true, general: true)
  scope :income,    where(income: true)
  scope :liability, where(liability: true)
  scope :slush,     where(expense: true, general: true)

  scope :tagged_with, lambda{|tag_or_tags| 
    if tag_or_tags.is_a?(Array)
      includes(:taggings).where('taggings.tag_id IN (?)', tag_or_tags.collect(&:id))
    else
      includes(:taggings).where('taggings.tag_id = ?', tag_or_tags.id)
    end
  }

  def core?
    household.cash           == self ||
    household.slush          == self ||
    household.general_income == self 
  end

  def balance
    debits.sum(:amount) - credits.sum(:amount)
  end

  def balance_on(date)
    debits.before(date).sum(:amount) - credits.before(date).sum(:amount)
  end

  # For funding deferred accounts from cash
  def fund
    transaction = debits.build credit: household.cash, date: Date.today, user: household.default_user, household: household

    if accruing?
      transaction.amount = budget
    else
      if balance < 0
        transaction.amount = budget + (balance * -1)
      else
        transaction.amount = budget - balance
      end
    end

    transaction.save

    transaction
  end

  def graph_step
    if (graph_end - graph_start) < 365
      7
    else
      30
    end
  end

  def graph_start
    transactions.order('date').first.date
  end

  def graph_end
    transactions.order('date DESC').first.date
  end

  def graph_x_axis
    (graph_start..graph_end).step(graph_step).collect{|d|d.strftime('%b %Y')}.to_json.html_safe
  end

  def graph_y_axis
    data = []

    (graph_start..graph_end).step(graph_step) do |date|
      value = balance_on(date)
      value = value * -1 if income?
      color = value < 0 ? '#FF00CC' : '#00CCFF'
      data << {y: value, marker:{fillColor: color}}
    end

    data.to_json.html_safe
  end
  
end
