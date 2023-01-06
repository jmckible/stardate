class AddVendorUniqueness < ActiveRecord::Migration[6.1]
  def change
    add_index :vendors, :name, unique: true
  end
end
