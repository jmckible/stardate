class Paycheck < ActiveRecord::Base
  
  belongs_to :item
  belongs_to :job
  
  has_many :tasks, :dependent=>:nullify
  
  scope :unpaid, where(item_id: nil)

  attr_accessor :paid
  def paid?
    item_id || paid == true || paid == 1
  end
  
  before_save :create_item
  def create_item
    if paid && !item
      job.user.items.create paycheck: self, explicit_value: "+#{value}", 
        description: description, date: Time.now.to_date
    end
  end

  attr_accessible :value
  
  validates_presence_of     :job_id
  validates_numericality_of :value

end
