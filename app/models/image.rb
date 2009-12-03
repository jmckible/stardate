class Image < ActiveRecord::Base
  belongs_to :item
  
  has_attached_file :source, 
    :styles=>{:large=>'800x800>', :small=>'75x75>'},
    :storage=>:s3,
    :s3_credentials=>"#{RAILS_ROOT}/config/s3.yml",
    :path=>"images/:id/:style.:extension"
  
  delegate :url, :to=>:source
  
  validates_attachment_presence :source
  validates_attachment_content_type :source, :content_type=>['image/jpeg', 'image/png', 'image/gif']
end
