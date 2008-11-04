require File.dirname(__FILE__) + '/../spec_helper'

describe ItemsController, 'without logging in' do
  it 'handles /' do
    get :index
    response.should redirect_to(new_session_path)
  end
end

describe ItemsController do
  define_models
  before do
    login_as :default
    @item = items(:default)
  end
  
  #############################################################################
  #                                  I N D E X                                #
  #############################################################################
  it 'handles /' do
    get :index
    response.should be_success
  end
  
  #############################################################################
  #                                    S H O W                                #
  #############################################################################
  it 'handles /items/:id with GET' do
    get :show, :id=>@item
    response.should be_success
  end
  
  #############################################################################
  #                                   C R E A T E                             #
  #############################################################################
  it 'handles /items with valid params and POST' do
    running {
      running {
        post :create, :item=>{:explicit_value=>20, :date=>Date.today, :description=>'twenty' }, :vendor=>{:name=>'new'}
        assigns(:item).value.should == -20
        assigns(:item).vendor.should == assigns(:vendor)
        response.should redirect_to(root_path)
      }.should change(Item, :count).by(1)
    }.should change(Vendor, :count).by(1)
  end
  
  it 'handles /items with no params and POST' do
    running {
      post :create, :item=>{}
      response.should redirect_to(root_path)
    }.should_not change(Item, :count)
  end
  
  it 'handles /items with no vendor and POST' do
    running {
      post :create, :item=>{:explicit_value=>20, :date=>Date.today, :description=>'twenty' }
      assigns(:item).value.should == -20
      response.should redirect_to(root_path)
    }.should change(Item, :count).by(1)
  end

  #############################################################################
  #                                   U P D A T E                             #
  #############################################################################
  it 'handles /items/:id with valid params and PUT' do
    put :update, :id=>@item, :item=>{:description=>'new'}, :vendor=>{:name=>vendors(:other).name}
    @item.reload.description.should == 'new'
    @item.vendor.should == vendors(:other)
    response.should redirect_to(root_path)
  end
  
  it 'handles /items/:id with emptying of vendor' do
    put :update, :id=>@item, :item=>{:description=>'new'}
    @item.reload.description.should == 'new'
    @item.vendor.should be_nil
    response.should redirect_to(root_path)
  end
  
  #############################################################################
  #                                 D E L E T E                               #
  #############################################################################
  it 'handles /items/:id with DELETE' do
    running {
      delete :destroy, :id=>@item
      response.should redirect_to(root_path)
    }.should change(Item, :count).by(-1)
  end
  
end