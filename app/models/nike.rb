class Nike < ActiveRecord::Base
  
  belongs_to :user
  
  scope :during, lambda { |date| where date: date }
  scope :on,     lambda { |date| where date: date }
  
  attr_accessible :date, :minutes, :user
  
  validates_presence_of :date, :user_id
  
end
