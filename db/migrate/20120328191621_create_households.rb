class CreateHouseholds < ActiveRecord::Migration
  def change
    create_table :households do |t|
      t.string :name
      t.timestamps
    end
    
    add_column :users, :household_id, :integer
    add_index  :users, :household_id
    
    add_column :items, :household_id, :integer
    add_index  :items, :household_id
  end
end
