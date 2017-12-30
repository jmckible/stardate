require 'rails_helper'

describe Recurring do
  before { @recurring = recurrings(:default) }

  it 'should convert to a new transaction' do
    transaction = recurrings(:default).to_transaction
    expect(transaction.date).to eq(Time.zone.today)
    expect(transaction.amount).to eq(100)
    expect(transaction.user).to eq(users(:default))
    expect(transaction.vendor).to eq(vendors(:default))
    expect(transaction.recurring).to eq(recurrings(:default))
  end

end
