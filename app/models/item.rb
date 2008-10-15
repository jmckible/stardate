class Item < ActiveRecord::Base
  include ExplicitValue
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  belongs_to :user
  belongs_to :vendor
  has_one    :paycheck,  :dependent=>:nullify

  #####################################################################
  #                           T A G G I N G                           #
  #####################################################################
  has_many :taggings, :as=>:taggable
  has_many :tags, :through=>:taggings, :order=>:name
  
  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(list)
    self.tags = list.split(',').compact.collect { |name| Tag.find_or_create_by_name name.strip }
  end
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :on,     lambda { |date| {:conditions=>{:date=>date}} }
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  attr_protected :user, :user_id
  
  validates_presence_of     :date, :user_id
  validates_numericality_of :value, :only_integer=>true

end
