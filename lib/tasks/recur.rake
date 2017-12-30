desc 'Create items from all the recurrings today'
task recur: :environment do
  Recurring.on(Time.zone.today).each do |recurring|
    transaction = recurring.to_transaction
    transaction.save
  end
end
