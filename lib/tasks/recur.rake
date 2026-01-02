desc 'Create items from all the recurrings today'
task recur: :environment do
  today = Time.zone.today
  recurrings = Recurring.on(today)

  puts "Processing recurring transactions for #{today.strftime('%Y-%m-%d')}..."
  puts "Found #{recurrings.count} recurring transaction(s)"

  created_count = 0
  recurrings.each do |recurring|
    transaction = recurring.to_transaction
    if transaction.save
      puts "  ✓ Created: #{transaction.description} ($#{transaction.amount})"
      created_count += 1
    else
      puts "  ✗ Failed: #{recurring.description} - #{transaction.errors.full_messages.join(', ')}"
    end
  end

  puts "Completed: #{created_count}/#{recurrings.count} transactions created"
end
