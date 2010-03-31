class Image < ActiveRecord::Base
  belongs_to :item
  
  has_attached_file :source
  
  delegate :url, :to=>:source
  
  validates_attachment_presence :source
  validates_attachment_content_type :source, :content_type=>['image/jpeg', 'image/png', 'image/gif']
end
