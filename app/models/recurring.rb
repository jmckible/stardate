class Recurring < ActiveRecord::Base

  explicit_integer :value

  belongs_to :user
  belongs_to :vendor
  
  named_scope :on, lambda { |date| {:conditions=>{:day=>(date.is_a?(Date) ? date.mday : date)}} }

  attr_protected :user, :user_id
  
  validates_presence_of     :user_id
  validates_numericality_of :value, :only_integer=>true
  validates_numericality_of :day, :in=>1..31
  
end
