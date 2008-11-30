class Twitter
  include HTTParty
  base_uri 'twitter.com'
  
  def initialize(user)
    @auth = {:username => user.twitter_username, :password => user.twitter_password}
  end
  
  # which can be :friends, :user or :public
  # options[:query] can be things like since, since_id, count, etc.
  def timeline(which=:friends, options={})
    options.merge!({:basic_auth => @auth})
    self.class.get("/statuses/#{which}_timeline.json", options)
  end

end