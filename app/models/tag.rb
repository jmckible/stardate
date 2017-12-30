class Tag < ApplicationRecord
  include Permalink

  scope :visible_by, ->(user){
    where("transactions.created_at >= ? AND (transactions.secret = ? OR transactions.user_id = ?)", user.created_at, false, user.id)
  }

  validates :name, presence: true, uniqueness: true
end
