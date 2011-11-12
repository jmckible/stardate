class Item < ActiveRecord::Base

  attach_vendor
  explicit_integer :value
  acts_as_taggable

  belongs_to :recurring
  belongs_to :user
  
  has_one :paycheck,  :dependent=>:nullify
  
  scope :during, lambda { |period|
    if period
      where "(start between ? and ?) or (finish between ? and ?) or (start <= ? and finish >= ?)", 
        period.first, period.last, period.first, period.last, period.first, period.last
    end
  }
  scope :on, lambda { |date| where date: date }
  scope :from_vendor, lambda { |vendor| where(vendor_id: vendor.id) if vendor }
  
  before_validation :amortize, :if=>:date
  def amortize
    self.start  = date unless start
    self.finish = date unless finish
    self.start, self.finish = finish, start if start > finish
    self.per_diem = value / ((finish - start).to_i + 1)
    true # Never halt
  end
  
  attr_accessible :date, :description, :finish, :explicit_value, :paycheck, :start, :tag_list
  
  validates_presence_of     :date, :user_id
  validates_numericality_of :value, :only_integer=>true

end
