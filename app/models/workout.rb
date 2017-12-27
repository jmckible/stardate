class Workout < ActiveRecord::Base

  belongs_to :user

  scope :during, ->(date){ where(date: date) }
  scope :on,     ->(date){ where(date: date) }

  scope :bike,       ->{ where(bike: true)       }
  scope :elliptical, ->{ where(elliptical: true) }
  scope :nike,       ->{ where(nike: true)       }
  scope :run,        ->{ where(run: true)        }

  def name
    if bike?
      'Bike'
    elsif elliptical?
      'Elliptical'
    elsif nike?
      'Nike Training Club'
    elsif p90x?
      'P90X'
    elsif run?
      'Run'
    elsif walk?
      'Walk'
    else
      'Workout'
    end
  end

  def to_s
    if bike?
      "Biked #{distance}mi / #{minutes}min"
    elsif elliptical
      "Elliptical #{distance}mi / #{minutes}min"
    elsif nike?
      "Nike Training Club #{minutes}min - #{description}"
    elsif p90x?
      "P90X #{description} - #{minutes}min"
    elsif run?
      "Ran #{distance}mi / #{minutes}min"
    elsif walk?
      "Walked #{distance}mi / #{minutes}min"
    elsif yoga?
      "Yoga #{minutes}min - #{description}"
    else
      'Workout'
    end
  end

  def export_start_at
    export_end_at - minutes.minutes
  end

  def export_end_at
    if date == created_at.to_date
      created_at
    else
      date.beginning_of_day + 10.hours
    end
  end

  validates_presence_of :date, :user_id

end
