class Transaction < ActiveRecord::Base
  include Taggable

  belongs_to :credit, class_name: 'Account'
  belongs_to :debit,  class_name: 'Account'
  belongs_to :household
  belongs_to :recurring
  belongs_to :user
  belongs_to :vendor

  has_one :paycheck

  scope :asset_credit, ->{ includes(:credit).where('accounts.asset = ?', true) }
  scope :asset_debit,  ->{ includes(:debit).where('accounts.asset = ?', true) }

  scope :deferred_credit, ->{ includes(:credit).where('accounts.deferred = ?', true) }
  scope :deferred_debit,  ->{ includes(:debit).where('accounts.deferred = ?', true) }

  scope :expense_credit, ->{ includes(:credit).where('accounts.expense = ?', true) }
  scope :expense_debit,  ->{ includes(:debit).where('accounts.expense = ?', true) }

  scope :income_credit, ->{ includes(:credit).where('accounts.income = ?', true) }
  scope :income_debit,  ->{ includes(:debit).where('accounts.income = ?', true) }

  scope :before, ->(date){ where("transactions.date <= ?", date) }
  scope :during, ->(period){
    if period
      where(date: period).order('transactions.date, transactions.id')
    end
  }
  scope :on, ->(date){ where date: date }
  scope :from_vendor, ->(vendor){ where(vendor_id: vendor.id) if vendor }

  scope :since, ->(date){ where("transactions.date >= ?", date)}

  # scope :tagged_with, ->(tag_or_tags){
  #   includes(:taggings).where(taggings: { tag_id: tag_or_tags.pluck(:id)}).references(:taggings)
  #
  #   # if tag_or_tags.is_a?(Array)
  #   #   includes(:taggings).where('taggings.tag_id IN (?)', tag_or_tags.collect(&:id)).references(:taggings)
  #   # else
  #   #   includes(:taggings).where('taggings.tag_id = ?', tag_or_tags.id).references(:taggings)
  #   # end
  # }

  scope :visible_by, ->(user){ where('transactions.date >= ? ', user.created_at)}

  def vendor_name
    vendor.try :name
  end

  def vendor_name=(string)
    if string.nil? || string.chop.blank?
      self.vendor = nil
    else
      self.vendor = Vendor.where(name: string).first_or_create
    end
  end

  validates_presence_of :date, :user_id
end
