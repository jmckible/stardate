class Household < ActiveRecord::Base
  include Totalling

  belongs_to :cash,           class_name: 'Account'
  belongs_to :general_income, class_name: 'Account'
  belongs_to :slush,          class_name: 'Account'

  has_many :accounts, ->{ order('accounts.name') }
  has_many :budgets
  has_many :users
  has_many :transactions

  has_many :expense_accounts, ->{ select('accounts.*, COUNT(debit_id) AS transaction_count, SUM(amount) AS total').where(accounts: { expense: true}).group('accounts.id').order('total desc') }, through: :transactions, source: :debit

  has_many :taggings, through: :transactions
  has_many :tags, ->{ order('tags.name').uniq }, through: :taggings do
    def visible_by(user)
      where("transactions.created_at >= ? AND (transactions.secret = ? OR transactions.user_id = ?)", user.created_at, false, user.id)
    end
  end

  has_many :vendors, ->{ order('vendors.name').uniq }, through: :transactions do
    def visible_by(user)
      where("transactions.created_at >= ? AND (transactions.secret = ? OR transactions.user_id = ?)", user.created_at, false, user.id)
    end
  end

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
