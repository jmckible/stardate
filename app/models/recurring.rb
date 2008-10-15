class Recurring < ActiveRecord::Base
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  belongs_to :user
  belongs_to :vendor
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  named_scope :on, lambda { |date| {:conditions=>{:day=>(date.is_a?(Date) ? date.mday : date)}} }
  
  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  # If the value is positive, put a + in front
  def explicit_value
    "#{'+' if value > 0}#{value}"
  end
  
  # Overwriting the default value=
  # Assume input without an explicit - or + preceeding is negative
  def explicit_value=(new_value)
    new_value = new_value.to_s
    return if new_value.blank?
    new_value = '-' + new_value unless new_value =~ /^(\+|-)/
    write_attribute :value, new_value.to_f.round
  end
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  attr_protected :user, :user_id
  
  validates_presence_of     :user_id
  validates_numericality_of :value, :only_integer=>true
  validates_numericality_of :day, :in=>1..31
  
end
