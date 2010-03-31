class Weight < ActiveRecord::Base
  
  belongs_to :user
  
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :on,     lambda { |date| {:conditions=>{:date=>date}} }
  
  attr_accessible :date, :weight, :body_fat
  
  validates_presence_of :date, :user_id
  
end
