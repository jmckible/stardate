class Tag < ActiveRecord::Base
  has_many :taggings, :dependent=>:destroy
  
  before_validation :strip_spaces
  def strip_spaces
    self.name = name.strip unless name.nil?
  end
  
  validates_presence_of   :name
  validates_uniqueness_of :name
end
