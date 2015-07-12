class Weight < ActiveRecord::Base

  belongs_to :user

  scope :during, ->(date){ where date: date }
  scope :on,     ->(date){ where date: date }

  validates_presence_of :date, :user_id

end
