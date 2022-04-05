require 'rails_helper'

describe RecurringsController do
  before { login_as :default }

  it 'handles /recurrings with GET' do
    gt recurrings_path
    expect(response).to be_successful
  end

  it 'handles /recurrings/:id with GET' do
    gt recurrings(:default)
    expect(response).to be_successful
  end

  it 'handles /recurrings/new with GET' do
    gt [:new, :recurring]
    expect(response).to be_successful
  end

  it 'handles /recurrings with valid params and POST' do
    expect {
      pst recurrings_path, recurring: { day: 1, amount: 10, debit_id: accounts(:rent).id, credit_id: accounts(:checking).id }
      expect(assigns(:recurring).user).to eq(users(:default))
      expect(response).to redirect_to(recurrings_path)
    }.to change(Recurring, :count).by(1)
  end

  it 'handles /recurrings/:id with valid params and PATCH' do
    recurring = recurrings(:default)
    ptch recurring, recurring: { amount: 1 }
    expect(recurring.reload.amount).to eq(1)
    expect(response).to redirect_to(recurrings_path)
  end

  it 'handles /recurrings/:id with DELETE' do
    expect {
      del recurrings(:default)
      expect(response).to redirect_to(recurrings_path)
    }.to change(Recurring, :count).by(-1)
  end

end
