class Tweet < ActiveRecord::Base
  belongs_to :user
  
  named_scope :during, lambda { |period| {:conditions=>{:created_at=>period}} }
  
  def date
    created_at.to_date
  end
  
  def url
    "http://twitter.com/#{user.twitter_username}/status/#{tweet_id}"
  end
  
  validates_presence_of :user_id
end
