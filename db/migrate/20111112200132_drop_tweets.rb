class DropTweets < ActiveRecord::Migration
  def up
    drop_table :tweets
    change_table :users do |t|
      t.remove :twitter_username, :twitter_password_b, :twitter_profile_image_url
    end
  end

  def down
    create_table "tweets", :force => true do |t|
      t.integer  "user_id"
      t.string   "tweet_id"
      t.string   "text"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    change_table :users do |t|
      t.string   "twitter_username"
      t.binary   "twitter_password_b"
      t.string   "twitter_profile_image_url"
    end
  end
end