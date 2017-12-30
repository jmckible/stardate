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
    cash.debits.on(period).sum(:amount)
  end

  def core_accounts
    [cash, general_income, slush].compact
  end

  validates :name, presence: true
end
