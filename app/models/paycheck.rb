class Paycheck < ActiveRecord::Base
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  belongs_to :item
  belongs_to :job
  
  has_many :tasks, :dependent=>:nullify
  
  #####################################################################
  #                             S C O P E                             #
  #####################################################################
  named_scope :unpaid, :conditions=>{:item_id=>nil}
  
  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  # Virtual attr paid for checkbox
  attr_accessor :paid
  def paid=(value)
    @paid = (value == true || value.to_i == 1) ? true : false
  end
  def paid?
    !@paid.nil? || !self.item_id.nil?
  end
  
  before_save :create_item
  def create_item
    if @paid==true && self.item_id.nil? 
      self.description ||= ''
      trans = job.user.items.build :value=>"+#{self.value.to_s}", :description=>self.description, :date=>Date.today
      self.item = trans if trans.save
    end
  end
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  validates_presence_of     :job_id
  validates_numericality_of :value
  
  protected
  def validate
    unless item_id.nil? || job_id.nil?
      errors.add(:item, "doesn't belong to you") unless item.user_id == job.user_id
    end
  end
end
