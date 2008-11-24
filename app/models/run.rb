class Run < ActiveRecord::Base
  
  belongs_to :user
  
  named_scope :on, lambda { |date| {:conditions=>{:date=>date}} }
  
  attr_accessible :date, :distance, :user
  
  validates_presence_of :date, :user_id
  
end
