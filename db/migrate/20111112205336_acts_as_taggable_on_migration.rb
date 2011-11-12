class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    add_column :taggings, :context, :string
    ActiveRecord::Base.connection.execute "update taggings set context = 'tags'"
    add_column :taggings, :tagger_id, :integer
    add_column :taggings, :tagger_type, :string
    add_index :taggings, [:taggable_id, :taggable_type, :context]
    remove_column :tags, :permalink
  end

  def self.down
    remove_column :taggings, :context
    remove_column :taggings, :tagger_id
    remove_column :taggings, :tagger_type
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
    add_column :tags, :permalink, :string
  end
end
