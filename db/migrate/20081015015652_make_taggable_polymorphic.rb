class MakeTaggablePolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :taggings, :item_id, :taggable_id
    add_column    :taggings, :taggable_type, :string
    add_index     :taggings, :taggable_type
    Tagging.update_all "taggable_type = 'Item'"
  end

  def self.down
    remove_column :taggings, :taggable_type
    rename_column :taggings, :taggable_id, :item_id
  end
end
