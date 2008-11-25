class Recurring < ActiveRecord::Base

  attach_vendor
  explicit_integer :value
  acts_as_taggable

  belongs_to :user
  
  named_scope :on, lambda { |date| {:conditions=>{:day=>(date.is_a?(Date) ? date.mday : date)}} }

  attr_accessible :day, :description, :explicit_value, :tag_list
  
  validates_presence_of     :user_id
  validates_numericality_of :value, :only_integer=>true
  validates_numericality_of :day, :in=>1..31
  
end
