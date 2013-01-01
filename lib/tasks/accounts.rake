namespace :accounts do

  task :fund=>:environment do
    if Date.today.day == 15 || (Date.today == Date.today.end_of_month)
      Household.all.each do |household|
        household.accounts.asset.where('budget > 0').each(&:fund)
      end
    end
  end

end