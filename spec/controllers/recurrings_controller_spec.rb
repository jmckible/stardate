require 'spec_helper'

describe RecurringsController do
  before { login_as :default }
  
  it 'handles /recurrings with GET' do
    get :index
    response.should be_success
  end
  
  it 'handles /recurrings/:id with GET' do
    get :show, :id=>recurrings(:default)
    response.should be_success
  end
  
  it 'handles /recurrings/new with GET' do
    get :new
    response.should be_success
  end
  
  it 'handles /recurrings with valid params and POST' do
    running {
      post :create, :recurring=>{:day=>1, :explicit_value=>10}
      assigns(:recurring).user.should == users(:default)
      response.should redirect_to(recurrings_path)
    }.should change(Recurring, :count).by(1)
  end
  
  it 'handles /recurrings/:id with valid params and GET' do
    recurring = recurrings(:default)
    put :update, :id=>recurring, :recurring=>{:description=>'updated'}
    recurring.reload.description.should == 'updated'
    response.should redirect_to(recurrings_path)
  end
  
  it 'handles /recurrings/:id with DELETE' do
    running {
      delete :destroy, :id=>recurrings(:default)
      response.should redirect_to(recurrings_path)
    }.should change(Recurring, :count).by(-1)
  end
  
end