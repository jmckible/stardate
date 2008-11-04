class Task < ActiveRecord::Base
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  belongs_to :job
  belongs_to :paycheck
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  named_scope :on,      lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :unpaid, :conditions=>{:paycheck_id=>nil}
  
  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
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
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  attr_accessible :date, :description, :hours, :min
  
  validates_presence_of :date, :job_id
  
  protected
  def validate
    if paycheck && job
      errors.add :paycheck, "doesn't belong to the job" if paycheck.job_id != job_id
    end
  end

end
