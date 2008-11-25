desc 'Create items from all the recurrings today' 
task :recur => :environment do
  Recurring.on(Date.today).each do |recurring|
    item = recurring.to_item
    item.save
  end
end