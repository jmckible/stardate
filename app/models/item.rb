class Item < ActiveRecord::Base

  explicit_integer :value
  is_taggable

  belongs_to :user
  belongs_to :vendor
  has_one    :paycheck,  :dependent=>:nullify
  
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :on,     lambda { |date| {:conditions=>{:date=>date}} }
  
  attr_protected :user, :user_id
  
  validates_presence_of     :date, :user_id
  validates_numericality_of :value, :only_integer=>true

end
