class Account < ApplicationRecord
  include Taggable

  enum :status, { active: 0, retired: 1 }
  enum :ledger, { asset: 0, income: 1, expense: 2, liability: 3 }

  belongs_to :deferral, class_name: 'Account', optional: true
  belongs_to :household

  has_many :credits, class_name: 'Transaction', foreign_key: 'credit_id', dependent: :nullify
  has_many :debits,  class_name: 'Transaction', foreign_key: 'debit_id',  dependent: :nullify

  def transactions
    household.transactions.where('debit_id = ? OR credit_id = ?', id, id)
  end

  scope :dashboard,  -> { where(dashboard: true) }
  scope :earmark,    -> { where(earmark: true) }
  scope :other_than, ->(account){ where.not(id: account.id) }

  # Efficiently load accounts with their balance totals computed in SQL using scalar subqueries
  scope :with_balances, -> {
    select('accounts.*,
            (SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE debit_id = accounts.id) as debit_total,
            (SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE credit_id = accounts.id) as credit_total')
  }

  # -------------------------------------------------------------------------- #
  #                               B A L A N C E                                #
  # -------------------------------------------------------------------------- #

  # Use precomputed total if available from with_balances scope, otherwise query
  def debit_total
    has_attribute?(:debit_total) ? read_attribute(:debit_total) : debits.sum(:amount)
  end

  def credit_total
    has_attribute?(:credit_total) ? read_attribute(:credit_total) : credits.sum(:amount)
  end

  def balance
    if has_attribute?(:debit_total) && has_attribute?(:credit_total)
      read_attribute(:debit_total) - read_attribute(:credit_total)
    else
      debits.sum(:amount) - credits.sum(:amount)
    end
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

  # For funding deferred accounts from checking
  def fund
    transaction = debits.build credit: household.checking, date: Time.zone.today, user: household.default_user, household: household

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

  # -------------------------------------------------------------------------- #
  #                              G R A P H I N G                               #
  # -------------------------------------------------------------------------- #

  def graph_step
    (graph_end - graph_start) < 365 ? 7 : 30
  end

  def graph_start
    transactions.order(:date).first.date
  end

  def graph_end
    transactions.order(date: :desc).first.date
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

  # -------------------------------------------------------------------------- #
  #                            V A L I D A T I O N                             #
  # -------------------------------------------------------------------------- #

  validates_presence_of :household_id, :name
end
