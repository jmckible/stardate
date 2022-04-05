class TagUniqueness < ActiveRecord::Migration[6.1]
  def up
    remove_index :tags, :name
    add_index :tags, :name, unique: true
  end
end
