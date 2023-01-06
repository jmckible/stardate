class AddPermalinkToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :permalink, :string
    add_index  :tags, :permalink
    Tag.reset_column_information
    Tag.all.each do |t|
      t.create_unique_permalink
      t.save
    end
  end

  def self.down
    remove_column :tags, :permalink
  end
end
