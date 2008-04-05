require File.dirname(__FILE__) + '/../test_helper'
require 'register_controller'

# Re-raise errors caught by the controller.
class RegisterController; def rescue_action(e) raise e end; end

class RegisterControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = RegisterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_must_login
    get :index
    assert_redirected_to login_path
  end
  
  def test_get_with_no_date
    login_as :jordan
    get :index
    assert_response :success
    assert_equal month_period, assigns(:period)
  end
  
  def test_get_with_year
    login_as :jordan
    get :index, :year=>2007
    assert_response :success
    assert_equal (Date.new(2007, 1, 1)..Date.new(2007, 12, 31)), assigns(:period)
  end
  
  def test_get_with_month
    login_as :jordan
    get :index, :year=>2007, :month=>1
    assert_response :success
    assert_equal (Date.new(2007, 1, 1)..Date.new(2007, 1, 31)), assigns(:period)
  end
  
  def test_get_with_month
    login_as :jordan
    get :index, :year=>2007, :month=>1, :day=>15
    assert_response :success
    assert_equal (Date.new(2007, 1, 15)..Date.new(2007, 1, 15)), assigns(:period)
  end
  
  def test_get_with_period
    login_as :jordan
    get :index, :year=>2007, :month=>1, :day=>1, :period=>30
    assert_response :success
    assert_equal (Date.new(2007, 1, 1)..Date.new(2007, 1, 31)), assigns(:period)
  end
  
  def test_post_with_params
    #login_as :jordan
    #post :index, 'date[year]'=>2007, 'date[month]'=>1
    #assert_response :success
    #assert_equal (Date.new(2007, 1, 1)..Date.new(2007, 1, 31)), assigns(:period)
  end
  
  protected
  def month_period(year=nil, month=nil)
    year  ||= Date.today.year
    month ||= Date.today.month
    (Date.new(year, month, 1)..Date.civil(year, month, -1))
  end
end
