require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RunsController do
  before { login_as :default }
  
  it 'handles /runs/:id with GET' do
    get :show, :id=>workouts(:run)
    response.should be_success
  end
  
  it 'handles /runs/:id with valid params and PUT' do
    run = workouts(:run)
    put :update, :id=>run, :run=>{:distance=>7}
    run.reload.distance.to_s.should == '7.0'
    response.should redirect_to(root_path)
  end
  
  it 'handles /runs/:id with DELETE' do
    running {
      delete :destroy, :id=>workouts(:run)
      response.should redirect_to(root_path)
    }.should change(Run, :count).by(-1)
  end

end
