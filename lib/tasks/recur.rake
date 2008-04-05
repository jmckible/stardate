desc 'Create items from all the recurrings today' 
task :recur => :environment do
  date = Time.now.utc.to_date
  puts "[#{Time.now.strftime('%F %T')}] Starting for #{date}"
  count = 0
  
  for recurring in Recurring.on(date)
    item = Item.new :date=>date, :value=>recurring.explicit_value, :description=>recurring.description
    item.user = recurring.user
    if item.save
      item.save
      puts "[#{Time.now.strftime('%F %T')}] Item #{item.id} saved" 
      count += 1
    else
      puts item.errors.full_messages
    end
  end
  
  puts "[#{Time.now.strftime('%F %T')}] Finished. #{count} items created"
end