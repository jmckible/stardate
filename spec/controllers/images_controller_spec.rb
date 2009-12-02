require 'spec_helper'

describe ImagesController do
  before { login_as :default }
  
  it 'handles /images/:id with owned image and GET' do
    get :show, :id=>images(:default)
    response.should be_success
  end
  
  it 'handles /images/:id with unowned image and GET' do
    get :show, :id=>images(:other)
    response.response_code.should == 404
  end
  
  it 'handles /images/:id with owned image and DELETE' do
    running {
      delete :destroy, :id=>images(:default)
      response.should redirect_to(root_url)
    }.should change(Image, :count).by(-1)
  end
  
  it 'handles /images/:id with unowned image and DELETE' do
    running {
      delete :destroy, :id=>images(:other)
      response.should redirect_to(root_url)
    }.should_not change(Image, :count)
  end
  
end