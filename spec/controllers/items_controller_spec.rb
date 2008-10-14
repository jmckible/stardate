require File.dirname(__FILE__) + '/../spec_helper'

describe ItemsController do
  
  #############################################################################
  #                                  I N D E X                                #
  #############################################################################
  it 'handles / without logging in' do
    get :index
    response.should redirect_to(new_session_path)
  end
  
  it 'handles / with logged in user' do
    login_as :jordan
    get :index
    response.should be_success
  end
  
  #############################################################################
  #                                    S H O W                                #
  #############################################################################
  it 'handles /items/:id with GET' do
    login_as :jordan
    get :show, :id=>items(:pizza)
    response.should be_success
  end
  
  #############################################################################
  #                                   C R E A T E                             #
  #############################################################################
  it 'handles /items with valid params and POST' do
    login_as :jordan
    running {
      running {
        post :create, :item=>{:value=>20, :date=>Date.today, :description=>'twenty' }, :vendor=>{:name=>'new'}
        assigns(:item).value.should == -20
        assigns(:item).vendor.should == assigns(:vendor)
        response.should redirect_to(items_path)
      }.should change(Item, :count).by(1)
    }.should change(Vendor, :count).by(1)
  end
  
  it 'handles /items with no params and POST' do
    login_as :jordan
    running {
      post :create, :item=>{}
      response.should redirect_to(items_path)
    }.should_not change(Item, :count)
  end
  
  it 'handles /items with no vendor and POST' do
    login_as :jordan
    running {
      post :create, :item=>{:value=>20, :date=>Date.today, :description=>'twenty' }
      assigns(:item).value.should == -20
      response.should redirect_to(items_path)
    }.should change(Item, :count).by(1)
  end

  #############################################################################
  #                                   U P D A T E                             #
  #############################################################################
  it 'handles /items/:id with valid params and PUT' do
    login_as :jordan
    item = items(:pizza)
    put :update, :id=>item, :item=>{:description=>'new'}, :vendor=>{:name=>vendors(:panera).name}
    item.reload.description.should == 'new'
    item.vendor.should == vendors(:panera)
    response.should redirect_to(items_path)
  end
  
  it 'handles /items/:id with emptying of vendor' do
    login_as :jordan
    item = items(:pizza)
    put :update, :id=>item, :item=>{:description=>'new'}
    item.reload.description.should == 'new'
    item.vendor.should be_nil
    response.should redirect_to(items_path)
  end
  
  #############################################################################
  #                                 D E L E T E                               #
  #############################################################################
  it 'handles /items/:id with DELETE' do
    login_as :jordan
    running {
      delete :destroy, :id=>items(:pizza)
      response.should redirect_to(items_path)
    }.should change(Item, :count).by(-1)
  end
  
end