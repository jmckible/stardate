require 'rails_helper'

describe RecurringsController do
  before { login_as :default }
  
  it 'handles /recurrings with GET' do
    get :index
    expect(response).to be_success
  end
  
  it 'handles /recurrings/:id with GET' do
    get :show, :id=>recurrings(:default)
    expect(response).to be_success
  end
  
  it 'handles /recurrings/new with GET' do
    get :new
    expect(response).to be_success
  end
  
  it 'handles /recurrings with valid params and POST' do
    expect(running {
      post :create, :recurring=>{:day=>1, :explicit_value=>10}
      expect(assigns(:recurring).user).to eq(users(:default))
      expect(response).to redirect_to(recurrings_path)
    }).to change(Recurring, :count).by(1)
  end
  
  it 'handles /recurrings/:id with valid params and GET' do
    recurring = recurrings(:default)
    put :update, :id=>recurring, :recurring=>{:description=>'updated'}
    expect(recurring.reload.description).to eq('updated')
    expect(response).to redirect_to(recurrings_path)
  end
  
  it 'handles /recurrings/:id with DELETE' do
    expect(running {
      delete :destroy, :id=>recurrings(:default)
      expect(response).to redirect_to(recurrings_path)
    }).to change(Recurring, :count).by(-1)
  end
  
end