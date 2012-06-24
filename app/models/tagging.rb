class Tagging < ActiveRecord::Base
  
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  
  validates :tag, presence: true, uniqueness: {scope: [:taggable_id, :taggable_type]} 
  validates_presence_of :taggable_id, :taggable_type
  
end