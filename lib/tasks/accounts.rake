namespace :accounts do

  task fund: :environment do
    today = Time.zone.today

    if [1, 15].include?(today.mday)
      puts "Running account funding for #{today.strftime('%Y-%m-%d')}..."

      Household.all.each do |household|
        puts "\nProcessing household: #{household.name || household.id}"

        # Track total variance for non-accruing accounts
        total_variance = 0
        funded_count = 0
        budgeted_accounts = household.accounts.asset.where('budget > 0')

        puts "  Found #{budgeted_accounts.count} budgeted account(s)"

        budgeted_accounts.each do |account|
          if account.accruing?
            puts "    #{account.name}: balance $#{account.balance} (accruing)"
          else
            # Non-accruing accounts: track variance before resetting
            current_balance = account.balance
            total_variance += current_balance
            puts "    #{account.name}: balance $#{current_balance} (variance)"
          end
          account.fund
          funded_count += 1
        end

        # Transfer variance to/from Accrued Savings
        if total_variance == 0
          puts "  ✓ Budget variance: Exactly on budget ($0)"
        else
          accrued_savings = household.accounts.find_by(name: 'Accrued Savings')

          if accrued_savings
            if total_variance.positive?
              # Under budget: Transfer excess to Accrued Savings
              Transaction.create!(
                household: household,
                user: household.default_user,
                date: today,
                debit: accrued_savings,
                credit: household.checking,
                amount: total_variance,
                description: "Budget savings (under by $#{total_variance})"
              )
              puts "  ✓ Budget variance: Under by $#{total_variance} → Accrued Savings"
            else
              # Over budget: Pull from Accrued Savings to cover
              deficit = total_variance.abs
              Transaction.create!(
                household: household,
                user: household.default_user,
                date: today,
                debit: household.checking,
                credit: accrued_savings,
                amount: deficit,
                description: "Budget deficit (over by $#{deficit})"
              )
              puts "  ✓ Budget variance: Over by $#{deficit} ← Accrued Savings"
            end
          else
            puts "  ⚠ Warning: No Accrued Savings account found, variance not tracked"
          end
        end

        puts "  Completed: #{funded_count} account(s) funded"
      end

      puts "\nAccount funding completed successfully"
    else
      puts "Skipping account funding - today is not the 1st or 15th"
    end
  end

end
