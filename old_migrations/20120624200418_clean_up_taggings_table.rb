class CleanUpTaggingsTable < ActiveRecord::Migration
  def up
    remove_column :taggings, :context
    remove_column :taggings, :tagger_id
    remove_column :taggings, :tagger_type
  end

  def down
  end
end
