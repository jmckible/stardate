require File.dirname(__FILE__) + '/../spec_helper'

describe ItemsController do
  
  it 'handles / without logging in' do
    get :index
    response.should redirect_to(new_session_path)
  end
  
  it 'handles / with logged in user' do
    login_as :jordan
    get :index
    response.should be_success
  end
  
end