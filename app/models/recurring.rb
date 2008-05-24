class Recurring < ActiveRecord::Base
  def self.on(date)
    find :all, :conditions=>{:day=>date.mday}
  end
  
  belongs_to :user
  
  def value=(new_value)
    new_value = new_value.to_s
    return if new_value.blank?
    new_value = '-' + new_value unless new_value =~ /^(\+|-)/
    write_attribute :value, new_value.to_f.round
  end
  
  def explicit_value
    return if value.nil?
    value < 0 ? value : "+#{value.to_s}"
  end
  
  # Consider overriding to_s?
  def inline_description
    description
  end
  
  validates_presence_of     :user_id
  validates_presence_of     :value
  validates_numericality_of :day
  validates_length_of       :description, :in=>0..254
  
  protected
  def validate
    unless day.nil?
      errors.add(:day, "must be between 1 and 28") if day < 1 or day > 28
    end
    unless self.user_id.blank?
      errors.add(:user, 'too many recurring transactions') if user.recurrings.size >= 100
    end
  end
  
end
