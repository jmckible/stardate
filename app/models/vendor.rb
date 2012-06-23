class Vendor < ActiveRecord::Base
  has_permalink :name
  
  has_many :items, order: 'created_at desc'
  
  def to_param() permalink end
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
end
