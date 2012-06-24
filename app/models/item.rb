class Item < ActiveRecord::Base
  include Taggable

  belongs_to :household
  belongs_to :recurring
  belongs_to :user
  belongs_to :vendor
  
  has_one :paycheck,  :dependent=>:nullify
  
  scope :during, lambda { |period|
    if period
      where "(start between ? and ?) or (finish between ? and ?) or (start <= ? and finish >= ?)", 
        period.first, period.last, period.first, period.last, period.first, period.last
    end
  }
  scope :on, lambda { |date| where date: date }
  scope :from_vendor, lambda { |vendor| where(vendor_id: vendor.id) if vendor }
  
  scope :tagged_with, lambda{|tag| includes(:taggings).where('taggings.tag_id = ?', tag.id)}
  
  before_validation :amortize, :if=>:date
  def amortize
    self.start  = date unless start
    self.finish = date unless finish
    self.start, self.finish = finish, start if start > finish
    self.per_diem = value / ((finish - start).to_i + 1).to_f
    true # Never halt
  end
  
  def explicit_value
    return if value.nil?
    "#{'+' if value > 0}#{value}"
  end
  
  def explicit_value=(new_integer)
    new_integer = new_integer.to_s
    return if new_integer.blank?
    new_integer = '-' + new_integer unless new_integer =~ /^(\+|-)/
    self.value = new_integer.to_f.round
  end
  
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
    
  validates_presence_of     :date, :user_id
  validates_numericality_of :value, :only_integer=>true

end
