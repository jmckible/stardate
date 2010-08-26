class Elliptical < ActiveRecord::Base
  
  belongs_to :user
  
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :on,     lambda { |date| {:conditions=>{:date=>date}} }
  
  attr_accessible :date, :distance, :minutes, :user
  
  validates_presence_of :date, :user_id
  
end
