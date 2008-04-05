class Item < ActiveRecord::Base
  ##########################################
  #       C L A S S   M E T H O D S        #
  ##########################################
  # Find all Items on a date or in a date range
  def self.on(date)
    find :all, :conditions=>{:date=>date}, :order=>:date
  end
  # Ideally during would be an alias of on, but not sure how to alias class methods
  def self.during(period)
    period = period.last..period.first if period.last < period.first
    find :all, :conditions=>{:date=>period}, :order=>:date
  end
  
  ##########################################
  #       C L A S S   M E T H O D S        #
  ##########################################
  belongs_to :user, :protected=>true
  
  has_many :taggings, :dependent=>:destroy
  has_many :tags, :through=>:taggings, :order=>:name
  
  has_one :paycheck, :dependent=>:nullify
  
  # Show tags as comma delimited list
  attr_accessor  :tag_list
  after_save     :update_tags
  def tag_names() tag_list || tags.collect(&:name).join(', ') end
  
  # Short description for display in calendars
  def calendar_description
    description.blank? ? date.strftime('%D') : description
  end
  
  # Put a + in front of any value 0 or greater
  def explicit_value
    return if value.nil?
    value < 0 ? value : "+#{value.to_s}"
  end
  
  # Overwriting the default value=
  # Assume input without an explicit - or + preceeding is negative
  def value=(new_value)
    new_value = new_value.to_s
    return if new_value.blank?
    new_value = '-' + new_value unless new_value =~ /^(\+|-)/
    write_attribute :value, new_value.to_f.round
  end
    
  validates_presence_of :user_id
  validates_presence_of :value
  validates_presence_of :date
  validates_length_of   :description, :in=>0..255
  
  protected
  def validate
    errors.add(:value, "can't be zero") if value == 0
  end
  
  def update_tags
    unless tag_list.blank?
      new_tags = tag_list.split(',').compact.collect{|name| Tag.find_or_create_by_name(name.strip)} 
      for tagging in taggings
        tagging.destroy unless new_tags.include?(tagging.tag)
      end
      for tag in new_tags
        Tagging.create :item=>self, :tag=>tag unless tags.include?(tag)
      end
    end
  end

end
