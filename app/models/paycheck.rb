class Paycheck < ActiveRecord::Base
  belongs_to :item
  belongs_to :job
  
  has_many :tasks, :dependent=>:nullify
  
  # Virtual attr paid for checkbox
  attr_accessor :paid
  def paid=(value)
    if value == true || value.to_i == 1
      @paid = true
    else
      @paid = false
    end
  end
  def paid?
    !@paid.nil? or !self.item_id.nil?
  end
  
  named_scope :unpaid, :conditions=>{:item_id=>nil}
  
  attr_protected :created_at
  
  validates_presence_of :job_id
  validates_numericality_of :value
  
  before_save :create_item # Wishing there was an :if=> param here
  
  protected  
  def create_item
    if @paid==true && self.item_id.nil? 
      self.description ||= ''
      trans = job.user.items.build :value=>"+#{self.value.to_s}", 
              :description=>self.description, :date=>Date.today
      self.item = trans if trans.save
    end
  end
  
  def validate
    unless item_id.nil? || job_id.nil?
      errors.add(:item, "doesn't belong to you") unless item.user_id == job.user_id
    end
  end
end
