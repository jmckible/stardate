namespace :accounts do

  task fund: :environment do
    if [1, 15].include?(Time.zone.today.mday)
      Household.all.each do |household|
        # Track total variance for non-accruing accounts
        total_variance = 0

        household.accounts.asset.where('budget > 0').each do |account|
          unless account.accruing?
            # Non-accruing accounts: track variance before resetting
            current_balance = account.balance
            total_variance += current_balance
          end
          account.fund
        end

        # Transfer variance to/from Accrued Savings
        if total_variance != 0
          accrued_savings = household.accounts.find_by(name: 'Accrued Savings')

          if accrued_savings
            if total_variance.positive?
              # Under budget: Transfer excess to Accrued Savings
              Transaction.create!(
                household: household,
                user: household.default_user,
                date: Time.zone.today,
                debit: accrued_savings,
                credit: household.checking,
                amount: total_variance,
                description: "Budget savings (under by $#{total_variance})"
              )
            else
              # Over budget: Pull from Accrued Savings to cover
              deficit = total_variance.abs
              Transaction.create!(
                household: household,
                user: household.default_user,
                date: Time.zone.today,
                debit: household.checking,
                credit: accrued_savings,
                amount: deficit,
                description: "Budget deficit (over by $#{deficit})"
              )
            end
          end
        end
      end
    end
  end

end
