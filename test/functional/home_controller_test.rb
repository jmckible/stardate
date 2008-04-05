require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_must_login_to_get_index
    get :index
    assert_redirected_to login_path
  end

  def test_get_index_with_session
    login_as :jordan
    get :index
    assert_response :success
    assert assigns(:period)
  end
  
  def test_get_index_with_nil_period
    login_as :new_guy
    get :index
    assert_response :success
    assert_nil assigns(:period)
  end
end
