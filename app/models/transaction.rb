class Transaction < ApplicationRecord
  include Taggable

  belongs_to :credit, class_name: 'Account', optional: true
  belongs_to :debit,  class_name: 'Account', optional: true
  belongs_to :household, touch: true
  belongs_to :recurring, optional: true
  belongs_to :user
  belongs_to :vendor, optional: true

  scope :asset_credit,    ->{ includes(:credit).where(accounts: { ledger: 'asset' }) }
  scope :asset_debit,     ->{ includes(:debit).where(accounts: { ledger: 'asset' }) }

  scope :deferred_credit, ->{ includes(:credit).where(accounts: { deferred: true }) }
  scope :deferred_debit,  ->{ includes(:debit).where(accounts: { deferred: true }) }

  scope :expense_credit,  ->{ includes(:credit).where(accounts: { ledger: 'expense' }) }
  scope :expense_debit,   ->{ includes(:debit).where(accounts: { ledger: 'expense' }) }

  scope :liability_credit,  ->{ includes(:credit).where(accounts: { ledger: 'liability' }) }
  scope :liability_debit,   ->{ includes(:debit).where(accounts: { ledger: 'liability' }) }

  scope :income_credit,   ->{ includes(:credit).where(accounts: { ledger: 'income' }) }
  scope :income_debit,    ->{ includes(:debit).where(accounts: { ledger: 'income' }) }

  scope :before, ->(date){ where("transactions.date <= ?", date) }
  scope :during, ->(period){ where(date: period).order('transactions.date, transactions.id') }
  scope :on, ->(date){ where date: date }
  scope :from_vendor, ->(vendor){ where(vendor_id: vendor.id) if vendor }

  scope :since, ->(date){ where("transactions.date >= ?", date)}

  scope :not_exceptional, ->{ where(exceptional: false) }
  scope :visible_by, ->(user){ where('transactions.date >= ? ', user.created_at)}

  def vendor_name
    vendor&.name
  end

  def vendor_name=(string)
    if string.blank?
      self.vendor = nil
    else
      self.vendor = Vendor.where(name: string).first_or_create
    end
  end

  validates_presence_of :date, :user_id
end
