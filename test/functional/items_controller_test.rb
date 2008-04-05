require File.dirname(__FILE__) + '/../test_helper'
require 'items_controller'

# Re-raise errors caught by the controller.
class ItemsController; def rescue_action(e) raise e end; end

class ItemsControllerTest < Test::Unit::TestCase
  fixtures :items, :users

  def setup
    @controller = ItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_must_login
    get :index
    assert_redirected_to login_path
  end

  def test_should_get_index_as_html
    login_as :jordan
    get :index
    assert_response 404
  end
  
  def test_should_get_index_as_xml
    login_as :jordan
    get :index, :format=>'xml'
    assert_response :success
    assert assigns(:items)
  end
  
  def test_should_get_index_as_xml_with_offset
    login_as :jordan
    get :index, :format=>'xml', :offset=>1
    assert_response :success
    assert assigns(:items)
  end
  
  def test_should_get_index_as_xml_with_date
    login_as :jordan
    get :index, :format=>'xml', :on=>Date.today.strftime("%Y%m%d")
    assert_response :success
    assert assigns(:items)
  end
  
  def test_should_get_index_as_xml_with_date_and_offset
    login_as :jordan
    get :index, :format=>'xml', :on=>Date.today.strftime("%Y%m%d"), :offset=>1
    assert_response :success
    assert assigns(:items)
  end

  def test_should_get_new
    login_as :jordan
    get :new
    assert_response :success
  end
  
  def test_should_create_item
    login_as :jordan
    old_count = Item.count
    post :create, :item => { :value=>'12', :description=>'something', :date=>Date.today}
    assert_equal old_count+1, Item.count
    
    assert_redirected_to home_path
  end

  def test_should_show_item_as_html
    login_as :jordan
    get :show, :id => 1
    assert_response 404
  end
  
  def test_should_show_item_as_xml
    login_as :jordan
    get :show, :id => 1, :format=>'xml'
    assert_response :success
    assert assigns(:item)
  end

  def test_should_get_edit
    login_as :jordan
    #get :edit, :id => 1
    #assert_response :success
  end
  
  def test_should_update_item
    login_as :jordan
    put :update, :id => 1, :item => { }
    assert_redirected_to register_path(:year=>Date.today.year, :month=>Date.today.month)
  end
  
  def test_should_destroy_item
    login_as :jordan
    old_count = Item.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Item.count
    
    assert_redirected_to register_path(:year=>Date.today.year, :month=>Date.today.month)
  end
  
  def test_should_redbox_destroy_item
    #login_as :jordan
    #old_count = Item.count
    #delete :redbox_destroy, :id => 1
    #assert_equal old_count-1, Item.count
    
    #assert_redirected_to home_path
  end
end
