require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_get_login
    get :login
    assert_response :success
  end
  
  def test_logout
    login_as :jordan
    cookie :user_id, users(:jordan).id
    cookie :password_has, users(:jordan).password_hash
    get :logout
    assert_redirected_to welcome_path
    assert_nil session[:user_id]
    assert_nil cookies[:user_id]
    assert_nil cookies[:password_hash]
  end
  
  def test_authenticate_success
    user = users(:jordan)
    post :authenticate, :email=>user.email, :password=>'test'
    assert_redirected_to home_path
  end
  
  def test_fail_authenticate
    post :authenticate, :email=>users(:jordan).email, :password=>'fake'
    assert_response :success
    assert_template 'login'
    assert flash[:notice]
  end
end
