class RemoveVendorPermalink < ActiveRecord::Migration
  def up
    remove_column :vendors, :permalink
  end

  def down
    add_column :vendors, :permalink, :string
    add_index  :vendors, :permalink
  end
end
