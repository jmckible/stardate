namespace :accounts do

  task fund: :environment do
    if Time.zone.today.mday == 1 || Time.zone.today.mday == 15
      Household.all.each do |household|
        household.accounts.asset.where('budget > 0').each(&:fund)
      end
    end
  end

end
