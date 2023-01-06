class AddTwitterPicToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_profile_image_url, :string
  end

  def self.down
    remove_column :users, :twitter_profile_image_url
  end
end
