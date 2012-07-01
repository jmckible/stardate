class AddPermalinkToTagsVendors < ActiveRecord::Migration
  def change
    add_column :tags, :permalink, :string
    add_index  :tags, :permalink
    
    add_column :vendors, :permalink, :string
    add_index  :vendors, :permalink
    
    Tag.all.each do |tag|
      tag.create_unique_permalink
      tag.save
    end
    
    Vendor.all.each do |vendor|
      vendor.create_unique_permalink
      vendor.save
    end
  end
end
