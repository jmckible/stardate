class Tag < ActiveRecord::Base
  has_many :taggings, :dependent=>:destroy
  has_many :items, :through=>:taggings 
  
  before_validation :strip_spaces
  def strip_spaces
    self.name = name.strip unless name.nil?
  end
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
