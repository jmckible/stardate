class Note < ApplicationRecord
  belongs_to :user

  scope :during, ->(date){ where(date: date) }
  scope :on,     ->(date){ where(date: date) }

  validates_presence_of :body, :date, :user_id
end
