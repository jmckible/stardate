require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NikesController do
  before { login_as :default }
  
  it 'handles /nikes/:id with GET' do
    get :show, id: workouts(:nike)
    response.should be_success
  end
  
  it 'handles /nikes/:id with valid params and PUT' do
    nike = workouts(:nike)
    put :update, id: nike, nike: {minutes: 40}
    nike.reload.minutes.should == 40
    response.should redirect_to(root_path)
  end
  
  it 'handles /nikes/:id with DELETE' do
    running {
      delete :destroy, id: workouts(:nike)
      response.should redirect_to(root_path)
    }.should change(Nike, :count).by(-1)
  end

end
