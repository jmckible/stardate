class Budget < ActiveRecord::Base
  
  belongs_to :household
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'
  
  default_scope order('budgets.amount DESC')
  
  def tag_name
    tag.try :name
  end
  
  def tag_name=(tag_name)
    self.tag = ActsAsTaggableOn::Tag.find_or_create_by_name tag_name
  end
  
  validates_presence_of   :household_id, :tag_id
  validates_uniqueness_of :tag_id, :scope=>:household_id
  
end