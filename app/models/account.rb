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
  scope :deferred,  where(deferred: true)
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

  def balance
    debits.sum(:amount) - credits.sum(:amount)
  end

  # For funding deferred accounts from cash
  def fund
    transaction = debits.build credit: household.cash, date: Date.today, user: household.default_user, household: household
    transaction.start = Date.today
    transaction.finish = Date.today
    transaction.description = "Deferral Funding"

    if accruing?
      transaction.amount = budget
    else
      transaction.amount = budget - balance
    end

    transaction.save

    transaction
  end
  
end
