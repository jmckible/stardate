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
  scope :unpaid, where(item_id:nil)
  
  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  # Virtual attr paid for checkbox
  attr_accessor :paid
  def paid?
    item_id || paid == true || paid == 1
  end
  
  before_save :create_item
  def create_item
    if paid && !item
      job.user.items.create paycheck: self, explicit_value: "+#{value}", 
        description: description, date: Date.today
    end
  end
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  attr_accessible :value
  
  validates_presence_of     :job_id
  validates_numericality_of :value

end
