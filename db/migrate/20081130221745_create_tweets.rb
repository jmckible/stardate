class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :user_id, :tweet_id
      t.string :text
      t.timestamps
    end
    
    add_column :users, :twitter_username, :string
    add_column :users, :twitter_password_b, :binary
  end

  def self.down
    drop_table :tweets
  end
end
