class CreateEquityAccounts < ActiveRecord::Migration
  def up
    Household.all.each do |household|

      tag = Tag.find_by_name 'paycheck'

      household.transactions.tagged_with(tag).collect{|t|t.vendor.name}.uniq.each do |account_name|
        equity = household.accounts.build name: account_name, income: true
        equity.save
      end

      household.transactions.tagged_with(tag).each do |transaction|
        account = household.accounts.income.where(name: transaction.vendor.name).first
        if transaction.amount >= 0
          transaction.update_attribute :credit, account
        else
          transaction.update_attribute :debit, account
        end
      end

    end
  end

  def down
  end
end
