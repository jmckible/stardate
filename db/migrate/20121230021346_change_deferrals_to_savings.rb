class ChangeDeferralsToSavings < ActiveRecord::Migration
  def up
    Account.where(deferred: true).each do |account|
      account.update_attribute :asset, true
    end
    remove_column :accounts, :deferred
  end

  def down
  end
end
