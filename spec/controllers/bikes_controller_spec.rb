require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BikesController do
  before { login_as :default }
  
  it 'handles /bikes/:id with GET' do
    get :show, :id=>bikes(:default)
    response.should be_success
  end
  
  it 'handles /bikes/:id with valid params and PUT' do
    bike = bikes(:default)
    put :update, :id=>bike, :bike=>{:distance=>7}
    bike.reload.distance.to_s.should == '7.0'
    response.should redirect_to(root_path)
  end
  
  it 'handles /bikes/:id with DELETE' do
    running {
      delete :destroy, :id=>bikes(:default)
      response.should redirect_to(root_path)
    }.should change(Bike, :count).by(-1)
  end

end
