class AddPermalinkToVendors < ActiveRecord::Migration
  def self.up
    add_column :vendors, :permalink, :string
    add_index  :vendors, :permalink
    Vendor.reset_column_information
    Vendor.all.each do |v|
      v.create_unique_permalink
      v.save
    end
  end

  def self.down
    remove_column :vendors, :permalink
  end
end
