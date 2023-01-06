class AddVendorToItemsAndJobs < ActiveRecord::Migration
  def self.up
    add_column :items, :vendor_id, :integer
    add_index  :items, :vendor_id
    
    Item.all.each do |item|
      unless item.description.blank?
        vendor = Vendor.find_or_create_by_name item.description
        item.update_attribute :vendor_id, vendor.id
      end
    end
    
    add_column :jobs, :vendor_id, :integer
    add_index  :jobs, :vendor_id
    
    Job.all.each do |job|
      unless job.name.blank?
        vendor = Vendor.find_or_create_by_name job.name
        job.update_attribute :vendor_id, vendor.id
      end
    end
  end

  def self.down
    remove_column :items, :vendor_id
    remove_column :jobs,  :vendor_id
  end
end
