class Tagging < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :taggable, polymorphic: true, optional: true
end
