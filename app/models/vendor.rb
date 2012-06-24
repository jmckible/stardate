class Vendor < ActiveRecord::Base
    
  has_many :items
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  validates :name, presence: true, uniqueness: true
  
end
