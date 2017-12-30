require 'rails_helper'

describe WeightsController do
  before { login_as :default }

  it 'handles /weights/:id with GET' do
    gt weights(:default)
    expect(response).to be_success
  end

  it 'handles /weights/:id with valid params and PATCH' do
    weight = weights(:default)
    ptch weight, weight: { weight: 150 }
    expect(weight.reload.weight).to eq(150.0)
    expect(response).to redirect_to(root_path)
  end

  it 'handles /weights/:id with DELETE' do
    expect {
      del weights(:default)
      expect(response).to redirect_to(root_path)
    }.to change(Weight, :count).by(-1)
  end

end
