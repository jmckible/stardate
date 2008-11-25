module AttachVendor
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def attach_vendor
      return if self.included_modules.include? AttachVendor::InstanceMethods
      __send__ :include, AttachVendor::InstanceMethods
      class_eval do
        belongs_to :vendor
        attr_accessible :vendor_name
      end
    end
  end
  
  module InstanceMethods
    def vendor_name
      vendor.try :name
    end
  
    def vendor_name=(string)
      if string.nil? || string.chop.blank?
        self.vendor = nil
      else
        v = Vendor.find_by_name string
        if v.nil?
          self.vendor = Vendor.new :name=>string
        else
          self.vendor = v
        end
      end
    end
  end
  
end