class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer    :item_id, :source_file_size
      t.string     :source_file_name, :source_content_type
      t.datetime   :source_updated_at
      t.timestamps
    end
    add_index :images, :item_id
  end

  def self.down
    drop_table :images
  end
end
