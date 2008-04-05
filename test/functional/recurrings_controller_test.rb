require File.dirname(__FILE__) + '/../test_helper'
require 'recurrings_controller'

# Re-raise errors caught by the controller.
class RecurringsController; def rescue_action(e) raise e end; end

class RecurringsControllerTest < Test::Unit::TestCase
  fixtures :recurrings, :users

  def setup
    @controller = RecurringsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_login_required
    get :index
    assert_redirected_to login_path
  end

  def test_should_get_index
    login_as :jordan
    get :index
    assert_response :success
    assert assigns(:recurrings)
  end

  def test_should_get_new
    login_as :jordan
    get :new
    assert_response :success
  end
  
  def test_should_create_recurring
    login_as :jordan
    old_count = Recurring.count
    post :create, :recurring => { :day=>1, :value=>20, :description=>"sub"}
    assert_equal old_count+1, Recurring.count
    
    assert_redirected_to recurrings_path
  end

  def test_should_show_recurring_as_html
    login_as :jordan
    get :show, :id => 1
    assert_response 404
  end

  def test_should_show_recurring_as_xml
    login_as :jordan
    get :show, :id => 1, :format=>'xml'
    assert_response :success
    assert assigns(:recurring)
  end
  
  def test_should_get_edit
    login_as :jordan
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_recurring
    login_as :jordan
    put :update, :id => 1, :recurring => { }
    assert_redirected_to recurrings_path
  end
  
  def test_should_destroy_recurring
    login_as :jordan
    old_count = Recurring.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Recurring.count
    
    assert_redirected_to recurrings_path
  end
end
