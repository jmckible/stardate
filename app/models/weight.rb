class Weight < ActiveRecord::Base
  belongs_to :user

  scope :during, ->(date){ where(date: date) }
  scope :on,     ->(date){ where(date: date) }

  def export_start_at
    if date == created_at.to_date
      created_at
    else
      date.beginning_of_day + 8.hours
    end
  end

  validates_presence_of :date, :user_id
end
