class Tag < ActiveRecord::Base
  include Permalink
  validates :name, presence: true, uniqueness: true
end
