class Vendor < ActiveRecord::Base
  include Permalink
  has_many :transactions
  validates :name, presence: true, uniqueness: true
end
