class Tag < ActiveRecord::Base
  has_permalink :name
  
  has_many :taggings
  
  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def count
    read_attribute(:count).to_i
  end
  
  def to_param() permalink end
  def to_s() name end
  def destroy_unused() false end
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
end