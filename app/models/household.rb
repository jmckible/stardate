class Household < ActiveRecord::Base
  include Totalling
  
  has_many :users
  has_many :items
  
  validates_presence_of :name
end
