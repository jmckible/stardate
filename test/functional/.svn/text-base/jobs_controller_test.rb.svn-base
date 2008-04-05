require File.dirname(__FILE__) + '/../test_helper'
require 'jobs_controller'

# Re-raise errors caught by the controller.
class JobsController; def rescue_action(e) raise e end; end

class JobsControllerTest < Test::Unit::TestCase
  fixtures :jobs, :users

  def setup
    @controller = JobsController.new
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
    assert assigns(:jobs)
  end

  def test_should_get_new
    login_as :jordan
    get :new
    assert_response :success
  end
  
  def test_should_create_job
    login_as :jordan
    old_count = Job.count
    post :create, :job => { :name=>'new', :rate=>100 }
    assert_equal old_count+1, Job.count
    
    assert_redirected_to job_path(assigns(:job))
  end

  def test_should_show_job
    login_as :jordan
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    login_as :jordan
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_job
    login_as :jordan
    put :update, :id => 1, :job => { }
    assert_redirected_to job_path(assigns(:job))
  end
  
  def test_should_destroy_job
    login_as :jordan
    old_count = Job.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Job.count
    
    assert_redirected_to jobs_path
  end
end
