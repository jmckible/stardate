class Household < ApplicationRecord
  include Totalling

  belongs_to :checking,       class_name: 'Account'
  belongs_to :credit_card,    class_name: 'Account'
  belongs_to :general_income, class_name: 'Account'
  belongs_to :slush,          class_name: 'Account'

  has_many :accounts, ->{ order('accounts.name') }, dependent: :destroy
  has_many :budgets,      dependent: :destroy
  has_many :users,        dependent: :destroy
  has_many :transactions, dependent: :destroy

  has_many :expense_accounts, ->{ select('accounts.*, COUNT(debit_id) AS transaction_count, SUM(amount) AS total').where(accounts: { ledger: 'expense'}).group('accounts.id').order(total: :desc) }, through: :transactions, source: :debit

  has_many :expense_tags, ->{ select('tags.*, COUNT(debit_id) AS transaction_count, SUM(amount) AS total').joins('INNER JOIN accounts ON transactions.debit_id = accounts.id').where(accounts: { ledger: 'expense'}).group('tags.id').order(total: :desc) }, through: :transactions, source: :tags

  has_many :taggings, through: :transactions
  has_many :tags, ->{ distinct.order('tags.name') }, through: :taggings

  has_many :vendors, ->{ distinct.order(name: :asc) }, through: :transactions

  # broadcasts_refreshes

  # For scheduled deferral funding
  def default_user
    users.first
  end

  def checking_income(period)
    checking.debits.during(period).sum(:amount)
  end

  def all_income(period)
    transactions.income_credit.during(period).sum(:amount)
  end

  def budget_month_values
    accounts.dashboard.with_balances.collect do |account|
      amount = account.balance
      {y: amount, color: (amount.negative? ? '#FF00CC' : '#00CCFF') }
    end
  end

  def core_accounts
    [checking, credit_card, general_income, slush].compact
  end

  def checking_plus_earmarks
    checking.balance + accounts.asset.earmark.with_balances.sum(&:balance)
  end

  validates :name, presence: true
end
