module ExplicitInteger
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def explicit_integer(*attributes)
      attributes.each do |attribute|
        
        define_method "explicit_#{attribute}", proc {
          return if __send__(attribute).nil?
          "#{'+' if __send__(attribute) > 0}#{__send__(attribute)}"
        }
        
        define_method "explicit_#{attribute}=", proc { |new_integer|
          new_integer = new_integer.to_s
          return if new_integer.blank?
          new_integer = '-' + new_integer unless new_integer =~ /^(\+|-)/
          write_attribute attribute.to_sym, new_integer.to_f.round
        }
        
      end
    end
  end
  
end