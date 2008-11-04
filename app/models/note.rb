class Note < ActiveRecord::Base
  belongs_to :user
  
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :on,     lambda { |date| {:conditions=>{:date=>date}} }
  
  attr_protected :user, :user_id
  
  validates_presence_of :body, :date, :user_id
end
