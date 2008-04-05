class Tagging < ActiveRecord::Base
  belongs_to :item
  belongs_to :tag
  
  validates_presence_of :tag, :item
  validates_uniqueness_of :tag_id, :scope=>:item_id
end
