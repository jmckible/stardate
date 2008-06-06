class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :item
  
  validates_presence_of   :tag_id, :item_id
  validates_uniqueness_of :tag_id, :scope=>:item_id
end
