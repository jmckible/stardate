class AbsValueAmounts < ActiveRecord::Migration
  def up
    Transaction.all.each do |transaction|
      transaction.update_attribute(:amount, (transaction.amount * -1)) if transaction.amount < 0
    end
  end

  def down
  end
end
