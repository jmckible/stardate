require 'rails_helper'

describe WeightsController do
  before { login_as :default }

  it 'handles /weights/:id with GET' do
    get :show, :id=>weights(:default)
    expect(response).to be_success
  end

  it 'handles /weights/:id with valid params and PUT' do
    weight = weights(:default)
    put :update, :id=>weight, :weight=>{:weight=>150}
    expect(weight.reload.weight).to eq(150.0)
    expect(response).to redirect_to(root_path)
  end

  it 'handles /weights/:id with DELETE' do
    expect(running {
      delete :destroy, :id=>weights(:default)
      expect(response).to redirect_to(root_path)
    }).to change(Weight, :count).by(-1)
  end

end
