class Item < ActiveRecord::Base
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  belongs_to :user
  has_one    :paycheck,  :dependent=>:nullify

  #####################################################################
  #                             T A G G I N G                         #
  #####################################################################
  has_many :taggings
  has_many :tags, :through=>:taggings, :order=>:name
  
  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(list)
    tags = list.split(',').compact.collect { |name| Tag.find_or_create_by_name name.strip }
  end
  
  #####################################################################
  #                               S C O P E                           #
  #####################################################################
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  
  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  # If the value is positive, put a + in front
  def explicit_value
    self.value < 0 ? value.to_s : "+#{value.to_s}"
  end
  
  # Overwriting the default value=
  # Assume input without an explicit - or + preceeding is negative
  def value=(new_value)
    new_value = new_value.to_s
    return if new_value.blank?
    new_value = '-' + new_value unless new_value =~ /^(\+|-)/
    write_attribute :value, new_value.to_f.round
  end
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  attr_protected :user, :user_id
  
  validates_presence_of     :date, :user_id
  validates_numericality_of :value, :only_integer=>true
  validates_length_of       :description, :in=>0..255

end
