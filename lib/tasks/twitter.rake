namespace :update do
  task :twitter => :environment do
    
    User.with_twitter.each do |user|
      begin
        Twitter.new(user).timeline(:user).each{|t| user.import_tweet t}
      rescue Net::HTTPServerException
        # Probably 401 "Unauthorized"
      end
    end
    
  end
end