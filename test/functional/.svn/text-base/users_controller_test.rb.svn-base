require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_new
    get :new
    assert_response :success
    assert session[:captcha]
    assert assigns(:captcha)
  end
  
  def test_should_create_user
    load_captcha
    old_count = User.count
    post :create, :user => { :email=>'new@test.com', :time_zone=>'Eastern Time (US & Canada)', 
         :password=>'test', :password_confirmation=>'test' }, :captcha=>session[:captcha]
    assert_equal old_count+1, User.count
    assert_redirected_to home_url
    assert assigns(:user)
  end
  
  def test_fail_create_no_password
    load_captcha
    old_count = User.count
    post :create, :user => { :email=>'new@test.com', :time_zone=>'Eastern Time (US & Canada)' }, :captcha=>session[:captcha]
    assert_equal old_count, User.count
    assert_response :success
    assert_template 'new'
    assert_equal @@error[:too_short].gsub('%d', '4'), assigns(:user).errors.on(:password)
  end
  
  def test_get_edit_for_self
    login_as :jordan
    get :edit, :id=>users(:jordan).id
    assert_response :success
    assert_equal users(:jordan), assigns(:user)
  end
  
  def test_get_edit_for_someone_else
    login_as :jordan
    get :edit, :id=>users(:scott).id
    assert_redirected_to edit_user_path(users(:jordan))
  end
  
  def test_update_self
    login_as :jordan
    put :update, :id=>users(:jordan).id, :user=>{:email=>'new@new.com'}
    assert_redirected_to edit_user_path(users(:jordan))
    assert_equal 'new@new.com', users(:jordan).reload.email
  end
  
  def test_update_with_wrong_id
    login_as :jordan
    other_email = users(:scott).email
    put :update, :id=>users(:scott).id, :user=>{:email=>'new@new.com'}
    assert_redirected_to edit_user_path(users(:jordan))
    assert_equal 'new@new.com', users(:jordan).reload.email
    assert_equal other_email, users(:scott).reload.email
  end
  
  protected
  def load_captcha
    get :new
    assert_response :success
  end

end
