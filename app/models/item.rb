class Item < ActiveRecord::Base

  explicit_integer :value
  acts_as_taggable

  belongs_to :user
  belongs_to :vendor
  has_one    :paycheck,  :dependent=>:nullify
  
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :on,     lambda { |date| {:conditions=>{:date=>date}} }
  
  def vendor_name
    vendor.try :name
  end
  
  def vendor_name=(string)
    if string.nil? || string.chop.blank?
      self.vendor = nil
    else
      v = Vendor.find_by_name string
      if v.nil?
        self.vendor = Vendor.new :name=>string
      else
        self.vendor = v
      end
    end
  end
  
  attr_accessible :date, :explicit_value, :description, :paycheck, :tag_list, :vendor, :vendor_name
  
  validates_presence_of     :date, :user_id
  validates_numericality_of :value, :only_integer=>true

end
