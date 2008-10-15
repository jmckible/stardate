module IsTaggable
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def is_taggable
      return if self.included_modules.include? IsTaggable::InstanceMethods
      __send__ :include, IsTaggable::InstanceMethods
    
      class_eval do       
        has_many :taggings, :as=>:taggable
        has_many :tags,     :through=>:taggings, :order=>:name
      end
    end
  end
  
  module InstanceMethods
    def tag_list
      tags.map(&:name).join(', ')
    end

    def tag_list=(list)
      self.tags = list.split(',').compact.collect { |name| Tag.find_or_create_by_name name.strip }
    end
  end
  
end