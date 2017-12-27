namespace :accounts do

  task fund: :environment do
    if Time.zone.today.day == 15 || (Time.zone.today == Time.zone.today.end_of_month)
      Household.all.each do |household|
        household.accounts.asset.where('budget > 0').each(&:fund)
      end
    end
  end

end
