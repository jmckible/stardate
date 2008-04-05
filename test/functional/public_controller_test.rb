require File.dirname(__FILE__) + '/../test_helper'
require 'public_controller'

# Re-raise errors caught by the controller.
class PublicController; def rescue_action(e) raise e end; end

class PublicControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = PublicController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_get_index_not_logged_in
    get :index
    assert_response :success
  end
  
  def test_index_redirect_home_with_session
    login_as :jordan
    get :index
    assert_redirected_to home_path
  end
  
  def test_index_redirect_home_with_cookie
    user = users(:jordan)
    cookie :user_id, user.id
    cookie :password_hash, user.password_hash
    get :index
    assert_redirected_to home_path
  end
  
  def test_get_index_with_invalid_cookie
    cookie :user_id, users(:jordan).id
    cookie :password_hash, 'fake'
    get :index
    assert_response :success
    assert_nil assigns(:user)
  end
  
  def test_should_get_screencast
    get :screencast
    assert_response :success
  end
  
end
