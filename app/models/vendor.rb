class Vendor < ActiveRecord::Base
  include Permalink
    
  has_many :items
  
  validates :name, presence: true, uniqueness: true
  
end
