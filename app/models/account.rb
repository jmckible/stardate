class Account < ApplicationRecord
  include Taggable

  enum status: [:active, :retired]

  belongs_to :deferral, class_name: 'Account', optional: true
  belongs_to :household

  has_many :credits, class_name: 'Transaction', foreign_key: 'credit_id', dependent: :nullify
  has_many :debits,  class_name: 'Transaction', foreign_key: 'debit_id',  dependent: :nullify

  def transactions
    household.transactions.where('debit_id = ? OR credit_id = ?', id, id)
  end

  scope :asset,          -> { where(asset: true) }
  scope :cash,           -> { where(asset: true, general: true) }
  scope :dashboard,      -> { where(dashboard: true) }
  scope :earmark,        -> { where(earmark: true) }
  scope :equity,         -> { where(equity: true) }
  scope :expense,        -> { where(expense: true) }
  scope :general_income, -> { where(income: true, general: true) }
  scope :income,         -> { where(income: true) }
  scope :liability,      -> { where(liability: true) }
  scope :slush,          -> { where(expense: true, general: true) }
  scope :other_than,     ->(account){ where.not(id: account.id) }

  #############################################################################
  #                                 B A L A N C E                             #
  #############################################################################
  def balance
    debits.sum(:amount) - credits.sum(:amount)
  end

  def balance_on(date)
    debits.before(date).sum(:amount) - credits.before(date).sum(:amount)
  end

  def balance_during(date)
    debits.during(date).sum(:amount) - credits.during(date).sum(:amount)
  end

  def core?
    household.core_accounts.include?(self)
  end

  # For funding deferred accounts from cash
  def fund
    transaction = debits.build credit: household.cash, date: Time.zone.today, user: household.default_user, household: household

    if accruing?
      transaction.amount = budget
    elsif balance.negative?
      transaction.amount = budget + (balance * -1)
    else
      transaction.amount = budget - balance
    end

    transaction.save

    transaction
  end

  #############################################################################
  #                                 G R A P H I N G                           #
  #############################################################################
  def graph_step
    (graph_end - graph_start) < 365 ? 7 : 30
  end

  def graph_start
    transactions.order('date').first.date
  end

  def graph_end
    transactions.order('date DESC').first.date
  end

  def graph_x_axis
    (graph_start..graph_end).step(graph_step).collect{|d| d.strftime('%b %Y')}.to_json.html_safe
  end

  def graph_y_axis
    data = []

    (graph_start..graph_end).step(graph_step) do |date|
      value = balance_on(date)
      value = value * -1 if income?
      color = value.negative? ? '#FF00CC' : '#00CCFF'
      data << { y: value, marker: { fillColor: color } }
    end

    data.to_json.html_safe
  end

  #############################################################################
  #                             V A L I D A T I O N                           #
  #############################################################################
  validates_presence_of :household_id, :name
end
