class Household < ApplicationRecord
  include Totalling

  belongs_to :cash,           class_name: 'Account'
  belongs_to :general_income, class_name: 'Account'
  belongs_to :slush,          class_name: 'Account'

  has_many :accounts, ->{ order('accounts.name') }, dependent: :destroy
  has_many :budgets,      dependent: :destroy
  has_many :users,        dependent: :destroy
  has_many :transactions, dependent: :destroy

  has_many :expense_accounts, ->{ select('accounts.*, COUNT(debit_id) AS transaction_count, SUM(amount) AS total').where(accounts: { expense: true}).group('accounts.id').order('total desc') }, through: :transactions, source: :debit

  has_many :expense_tags, ->{ select('tags.*, COUNT(debit_id) AS transaction_count, SUM(amount) AS total').joins('INNER JOIN accounts ON transactions.debit_id = accounts.id').where(accounts: { expense: true}).group('tags.id').order('total desc') }, through: :transactions, source: :tags

  has_many :taggings, through: :transactions
  has_many :tags, ->{ distinct.order('tags.name') }, through: :taggings

  has_many :vendors, ->{ distinct.order(name: :asc) }, through: :transactions

  # For scheduled deferral funding
  def default_user
    users.first
  end

  def cash_income(period)
    cash.debits.during(period).sum(:amount)
  end

  def all_income(period)
    transactions.income_credit.during(period).sum(:amount)
  end

  def core_accounts
    [cash, general_income, slush].compact
  end

  def cash_minus_earmarks
    cash.balance - accounts.asset.earmark.collect{|a| a.balance.abs}.sum
  end

  def biweekly_budget_balance
    if Time.zone.today.mday >= 15
      date = (Date.new Time.zone.today.year, Time.zone.today.month, 15).beginning_of_day
    else
      date = (Date.new Time.zone.today.year, Time.zone.today.month, 1).beginning_of_day
    end

    spending = cash.credits.expense_debit.since(date).not_exceptional.sum(:amount)
    3000 - spending - accounts.sum(:budget)
  end

  def last_period_budget_balance
    if Time.zone.today.mday >= 15
      range = Date.new(Time.zone.today.year, Time.zone.today.month, 1)..Date.new(Time.zone.today.year, Time.zone.today.month, 15)
    else
      last_month = 1.month.ago
      range = Date.new(last_month.year, last_month.month, 15)..last_month.end_of_month
    end

    spending = cash.credits.expense_debit.during(range).not_exceptional.sum(:amount)
    3000 - spending - accounts.sum(:budget)
  end

  validates :name, presence: true
end
