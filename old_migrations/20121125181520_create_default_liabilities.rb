class CreateDefaultLiabilities < ActiveRecord::Migration
  def up
    Household.all.each do |household|

      household.accounts.expense.each do |account|
        household.transactions.tagged_with(account.tags).each do |transaction|
          if transaction.amount < 0
            transaction.update_attribute :debit, account
          else
            transaction.update_attribute :credit, account
          end
        end
      end

    end
  end

  def down
  end
end
