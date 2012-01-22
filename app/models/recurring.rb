class Recurring < ActiveRecord::Base
  
  acts_as_taggable

  belongs_to :user
  belongs_to :vendor
  
  has_many :items, :dependent=>:nullify
  
  scope :on, lambda { |date|
    if date.is_a?(Date)
      if date == date.end_of_month
        where("day >= ?", date.mday)
      else
       where(day: date.mday)
      end
    else
      where(day: date)
    end
  }
  
  def to_item
    item = Item.new date: Date.today,
                    description: description,
                    explicit_value: explicit_value,
                    tag_list: tag_list,
                    vendor_name: vendor_name
    item.recurring  = self
    item.user       = user
    item
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

  attr_accessible :day, :description, :explicit_value, :tag_list, :vendor_name
  
  validates_presence_of     :user_id
  validates_numericality_of :value, only_integer: true
  validates_numericality_of :day, in: 1..31
  
end
