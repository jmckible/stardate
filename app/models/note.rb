class Note < ActiveRecord::Base
  belongs_to :user
  
  scope :during, lambda { |date| where date: date }
  scope :on,     lambda { |date| where date: date }
  
  validates_presence_of :body, :date, :user_id
end
