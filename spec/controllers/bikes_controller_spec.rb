require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BikesController do
  before { login_as :default }
  
  it 'handles /bikes/:id with GET' do
    get :show, :id=>workouts(:bike)
    response.should be_success
  end
  
  it 'handles /bikes/:id with valid params and PUT' do
    bike = workouts(:bike)
    put :update, :id=>bike, :bike=>{:distance=>7}
    bike.reload.distance.to_s.should == '7.0'
    response.should redirect_to(root_path)
  end
  
  it 'handles /bikes/:id with DELETE' do
    running {
      delete :destroy, :id=>workouts(:bike)
      response.should redirect_to(root_path)
    }.should change(Bike, :count).by(-1)
  end

end
