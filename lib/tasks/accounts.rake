namespace :accounts do

  task :fund=>:environment do
    if Date.today.day == 1 || Date.today.day == 15
      Household.all.each do |household|
        household.accounts.deferred.all.each(&:fund)
      end
    end
  end

end