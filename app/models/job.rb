class Job < ActiveRecord::Base
  def self.active
    find :all, :conditions=>{:active=>true}, :order=>:name
  end
  
  belongs_to :user
  
  has_many :paychecks, :order=>:created_at, :dependent=>:destroy do
    def unpaid
      find :all, :conditions=>{:item_id=>nil}
    end
  end
  
  has_many :tasks, :order=>:date, :dependent=>:destroy do
    def on(date)
      find :all, :conditions=>{:date=>date}
    end
    alias :within :on
    def unpaid
      find :all, :conditions=>{:paycheck_id=>nil}
    end
    def minutes_on(date)
      return (sum :minutes, :conditions=>{:date=>date}) || 0
    end
  end
  
  attr_protected :created_at
  
  validates_uniqueness_of   :name
  validates_presence_of     :name
  validates_presence_of     :user_id
  validates_presence_of     :rate
  validates_numericality_of :rate
  
  protected
  def validate
    unless self.user_id.blank?
      errors.add(:user, 'too many jobs') if user.jobs.size >= 50
    end
  end
end
