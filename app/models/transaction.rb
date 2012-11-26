class Transaction < ActiveRecord::Base
  include Taggable

  belongs_to :credit, class_name: 'Account'
  belongs_to :debit, class_name: 'Account'
  belongs_to :household
  belongs_to :recurring
  belongs_to :user
  belongs_to :vendor
  
  has_one :paycheck

  scope :asset_credit, includes(:credit).where('accounts.asset = ?', true)
  scope :asset_debit,  includes(:debit).where('accounts.asset = ?', true)

  scope :expense_credit, includes(:credit).where('accounts.expense = ?', true)
  scope :expense_debit,  includes(:debit).where('accounts.expense = ?', true)

  scope :income_credit, includes(:credit).where('accounts.income = ?', true)
  scope :income_debit,  includes(:debit).where('accounts.income = ?', true)
  
  scope :during, lambda { |period|
    if period
      where "(start between ? and ?) or (finish between ? and ?) or (start <= ? and finish >= ?)", 
        period.first, period.last, period.first, period.last, period.first, period.last
    end
  }
  scope :on, lambda { |date| where date: date }
  scope :from_vendor, lambda { |vendor| where(vendor_id: vendor.id) if vendor }
  
  scope :since, lambda{|date| where("items.created_at >= ?", date)}
  
  scope :tagged_with, lambda{|tag_or_tags| 
    if tag_or_tags.is_a?(Array)
      includes(:taggings).where('taggings.tag_id IN (?)', tag_or_tags.collect(&:id))
    else
      includes(:taggings).where('taggings.tag_id = ?', tag_or_tags.id)
    end
  }
  
  # before_validation :amortize, :if=>:date
  # def amortize
  #   self.start  = date unless start
  #   self.finish = date unless finish
  #   self.start, self.finish = finish, start if start > finish
  #   self.per_diem = value / ((finish - start).to_i + 1).to_f
  #   true # Never halt
  # end
  
  def vendor_name
    vendor.try :name
  end

  def vendor_name=(string)
    if string.nil? || string.chop.blank?
      self.vendor = nil
    else
      self.vendor = Vendor.find_or_create_by_name string
    end
  end
    
  validates_presence_of :date, :user_id
end