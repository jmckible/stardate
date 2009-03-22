require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do 
  before { login_as :default }
  
  it 'handles /users/:id/edit with GET' do
    get :edit, :id=>@current_user
    response.should be_success
  end
  
  it 'handles /users/:id with valid params and PUT' do
    put :update, :id=>@current_user, :user=>{:email=>'new@email.com'}
    @current_user.reload.email.should == 'new@email.com'
    response.should redirect_to(edit_user_path(@current_user))
  end
  
  it 'handles /users/:id with invalid params and PUT' do
    put :update, :id=>@current_user, :user=>{:email=>''}
    @current_user.reload.email.should_not be_blank
    response.should render_template(:edit)
    response.should be_success
  end
  
end