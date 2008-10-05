require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do
  
  it 'handles /sessions/new with GET' do
    get :new
    response.should be_success
  end
  
  it 'redirects to root path on request to /sessions/new with logged in user and GET' do
    login_as :jordan
    get :new
    response.should redirect_to(root_path)
  end
  
  it 'logs in a user with valid credentials' do
    user = users(:jordan)
    post :create, :email=>user.email, :password=>'test'
    response.should redirect_to(root_path)
    session[:user_id].should == user.id
    response.cookies['user_id'].first.should == user.id.to_s
    response.cookies['password_hash'].first.should == user.password_hash
  end
  
  it 'denies access to a user with invalid credentials' do
    post :create
    response.should render_template(:new)
    response.should be_success
  end
  
  it 'logs out a user' do
    login_as :jordan
    delete :destroy, :id=>@current_user.id
    response.should redirect_to(new_session_path)
    session[:user_id].should be_nil
    response.cookies['user_id'].should be_empty
    response.cookies['password_hash'].should be_empty
  end
  
end