class Transaction < ApplicationRecord
  include Taggable

  belongs_to :credit, class_name: 'Account', optional: true
  belongs_to :debit,  class_name: 'Account', optional: true
  belongs_to :household
  belongs_to :recurring, optional: true
  belongs_to :user
  belongs_to :vendor, optional: true

  has_one :paycheck, dependent: :nullify

  scope :asset_credit,    ->{ includes(:credit).where('accounts.asset = ?', true) }
  scope :asset_debit,     ->{ includes(:debit).where('accounts.asset = ?', true) }

  scope :deferred_credit, ->{ includes(:credit).where('accounts.deferred = ?', true) }
  scope :deferred_debit,  ->{ includes(:debit).where('accounts.deferred = ?', true) }

  scope :expense_credit,  ->{ includes(:credit).where('accounts.expense = ?', true) }
  scope :expense_debit,   ->{ includes(:debit).where('accounts.expense = ?', true) }

  scope :income_credit,   ->{ includes(:credit).where('accounts.income = ?', true) }
  scope :income_debit,    ->{ includes(:debit).where('accounts.income = ?', true) }

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
