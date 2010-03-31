class Image < ActiveRecord::Base
  belongs_to :item
  
  has_attached_file :source
end
