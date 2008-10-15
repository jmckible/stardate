class AddVendorToRecurrings < ActiveRecord::Migration
  def self.up
    add_column :recurrings, :vendor_id, :integer
    add_index  :recurrings, :vendor_id
    
    Recurring.all.each do |r|
      unless r.description.blank?
        vendor = Vendor.find_or_create_by_name r.description
        r.update_attribute :vendor_id, vendor.id
      end
    end
    
    Recurring.update_all "description = null"
    
  end

  def self.down
    remove_column :recurrings, :vendor_id
  end
end
