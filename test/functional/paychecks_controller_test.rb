require File.dirname(__FILE__) + '/../test_helper'
require 'paychecks_controller'

# Re-raise errors caught by the controller.
class PaychecksController; def rescue_action(e) raise e end; end

class PaychecksControllerTest < Test::Unit::TestCase
  fixtures :paychecks, :users, :items, :jobs

  def setup
    @controller = PaychecksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_must_login
    get :index, :job_id=>jobs(:risi).to_param
    assert_redirected_to login_path
  end

  def test_should_get_index_as_html
    login_as :jordan
    get :index, :job_id=>jobs(:risi).to_param
    assert_response 404
  end
  
  def test_should_get_index_as_xml
    login_as :jordan
    get :index, :job_id=>jobs(:risi).to_param, :format=>'xml'
    assert_response :success
    assert assigns(:paychecks)
  end

  def test_should_show_paycheck_as_html
    login_as :jordan
    get :show, :id => 1, :job_id=>jobs(:risi).to_param
    assert_response 404
  end
  
  def test_should_show_paycheck_as_xml
    login_as :jordan
    get :show, :id=>1, :job_id=>jobs(:risi).to_param, :format=>'xml'
    assert_response :success
    assert assigns(:paycheck)
  end

  def test_should_get_new
    login_as :jordan
    get :new, :job_id=>jobs(:risi).to_param
    assert_response :success
  end
  
  def test_should_get_edit
    login_as :jordan
    get :edit, :id => 1, :job_id=>jobs(:risi).to_param
    assert_response :success
  end
  
  def test_should_create_paycheck
    login_as :jordan
    old_count = Paycheck.count
    post :create, :paycheck => { :value=>12  }, :job_id=>jobs(:risi).to_param
    assert_equal old_count+1, Paycheck.count
    
    assert_redirected_to job_path(jobs(:risi))
  end

  def test_should_update_paycheck
    login_as :jordan
    put :update, :id => 1, :paycheck => { }, :job_id=>jobs(:risi).to_param
    assert_redirected_to job_path(jobs(:risi))
  end
  
  def test_should_destroy_paycheck
    login_as :jordan
    old_count = Paycheck.count
    delete :destroy, :id => 1, :job_id=>jobs(:risi).to_param
    assert_equal old_count-1, Paycheck.count
    
    assert_redirected_to job_path(jobs(:risi))
  end
end
