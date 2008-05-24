class Task < ActiveRecord::Base
  def self.on(date)
    find :all, :conditions=>{:date=>date}
  end
  
  belongs_to :job
  belongs_to :paycheck
  
  attr_accessor :hours, :min
  def hours
    return if minutes.blank?
    minutes < 60 ? nil : minutes.div(60)
  end
  def min
    return if minutes.blank?
    min = minutes.modulo(60)
    min < 10 ? "0#{min}" : min
  end
  
  attr_protected :created_at
  
  before_validation :fix_minutes
  
  validates_presence_of :job_id
  validates_presence_of :date
  validates_presence_of :minutes
  
  protected
  def validate
    errors.add(:minutes, "can't be zero") if minutes == 0
    unless paycheck_id.nil? or job_id.nil?
      errors.add(:paycheck, "doesn't belong to the job") if paycheck.job_id != job.id
    end
  end
  
  def fix_minutes
    unless @hours.blank? and @min.blank?
      @hours ||= 0
      @min   ||= 0
      self.minutes = @hours.to_f * 60 + @min.to_i
    end
  end
  
end
