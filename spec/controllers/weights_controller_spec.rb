require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WeightsController do
  before { login_as :default }
  
  it 'handles /weights/:id with GET' do
    get :show, :id=>weights(:default)
    response.should be_success
  end
  
  it 'handles /weights/:id with valid params and PUT' do
    weight = weights(:default)
    put :update, :id=>weight, :weight=>{:weight=>150}
    weight.reload.weight.should == 150.0
    response.should redirect_to(root_path)
  end
  
  it 'handles /weights/:id with DELETE' do
    running {
      delete :destroy, :id=>weights(:default)
      response.should redirect_to(root_path)
    }.should change(Weight, :count).by(-1)
  end

end