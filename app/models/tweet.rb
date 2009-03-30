class Tweet < ActiveRecord::Base
  belongs_to :user
  
  named_scope :during, lambda { |period| {:conditions=>{:created_at=>period}} }
  
  def date
    created_at.to_date
  end
  
  def url
    "http://twitter.com/#{user.twitter_username}/status/#{tweet_id}"
  end
  
  def autolink_text
    return '' unless text
    text.gsub(/http:\/\/\S+/) { |url| 
      "<a href=\"#{url}\">#{url}</a>"
    }.gsub(/@\S+/) { |username|
      "<a href=\"http://twitter.com/#{username.delete('@')}\">#{username}</a>"
    }
  end
  
  validates_presence_of :user_id
end
