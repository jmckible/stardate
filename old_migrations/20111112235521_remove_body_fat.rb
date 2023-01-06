class RemoveBodyFat < ActiveRecord::Migration
  def up
    remove_column :weights, :body_fat
  end

  def down
    add_column :weights, :body_fat,  :decimal, precision: 4, scale: 1
  end
end
