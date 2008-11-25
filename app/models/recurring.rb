class Recurring < ActiveRecord::Base

  attach_vendor
  explicit_integer :value
  acts_as_taggable

  belongs_to :user
  
  has_many :items, :dependent=>:nullify
  
  named_scope :on, lambda { |date|
    if date.is_a?(Date)
      if date == date.end_of_month
        {:conditions=>["day >= ?", date.mday]}
      else
        {:conditions=>{:day=>date.mday}}
      end
    else
      {:conditions=>{:day=>date}}
    end
  }
  
  def to_item
    item = Item.new :date=>Date.today,
                    :description=>description,
                    :explicit_value=>explicit_value,
                    :tag_list=>tag_list,
                    :vendor_name=>vendor_name
    item.recurring  = self
    item.user       = user
    item
  end

  attr_accessible :day, :description, :explicit_value, :tag_list
  
  validates_presence_of     :user_id
  validates_numericality_of :value, :only_integer=>true
  validates_numericality_of :day, :in=>1..31
  
end
