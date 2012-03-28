require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EllipticalsController do
  before { login_as :default }
  
  it 'handles /ellipticals/:id with GET' do
    get :show, :id=>workouts(:elliptical)
    response.should be_success
  end
  
  it 'handles /ellipticals/:id with valid params and PUT' do
    elliptical = workouts(:elliptical)
    put :update, :id=>elliptical, :elliptical=>{:distance=>7}
    elliptical.reload.distance.to_s.should == '7.0'
    response.should redirect_to(root_path)
  end
  
  it 'handles /ellipticals/:id with DELETE' do
    running {
      delete :destroy, :id=>workouts(:elliptical)
      response.should redirect_to(root_path)
    }.should change(Elliptical, :count).by(-1)
  end

end
