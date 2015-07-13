class Task < ActiveRecord::Base

  belongs_to :job
  belongs_to :paycheck

  scope :on,      ->(date){ where date: date }
  scope :unpaid,  ->{ where(paycheck_id: nil) }

  attr_accessor :hours, :min
  def hours
    return if minutes.blank?
    minutes < 60 ? nil : minutes.div(60)
  end
  def min
    return if minutes.blank?
    modulo = minutes.modulo(60)
    modulo < 10 ? "0#{modulo}" : modulo
  end

  before_validation :fix_minutes
  def fix_minutes
    unless @hours.blank? && @min.blank?
      @hours ||= 0
      @min   ||= 0
      self.minutes = @hours.to_f * 60 + @min.to_i
    end
  end


  attr_accessible :date, :description, :hours, :min

  validates_presence_of :date, :job_id

end
