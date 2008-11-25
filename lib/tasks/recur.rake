desc 'Create items from all the recurrings today' 
task :recur => :environment do
  Recurring.on(Date.today).each do |recurring|
    recurring.to_item.save
  end
end