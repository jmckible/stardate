class Job < ActiveRecord::Base

  belongs_to :user
  belongs_to :vendor
  
  has_many   :paychecks, :dependent=>:destroy
  has_many   :tasks,     :dependent=>:destroy
  
  scope :active, -> {where(active: true)}
  
  validates_presence_of     :name, :user_id
  validates_numericality_of :rate

end
