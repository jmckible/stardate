class Tag < ActiveRecord::Base
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  validates :name, presence: true, uniqueness: true
  
end