require File.dirname(__FILE__) + '/../spec_helper'

describe ItemsController do
  
  it 'handles / without logging in' do
    get :index
    response.should redirect_to(new_session_path)
  end
  
  it 'handles / with logged in user' do
    login_as :jordan
    get :index
    response.should be_success
  end
  
  it 'handles /items with valid params and POST' do
    login_as :jordan
    running {
      post :create, :item=>{:value=>20, :date=>Date.today, :description=>'twenty' }
      assigns(:item).value.should == -20
      response.should redirect_to(items_path)
    }.should change(Item, :count).by(1)
  end
  
  it 'handles /items/:id with GET' do
    login_as :jordan
    get :show, :id=>items(:pizza)
    response.should be_success
  end
  
  it 'handles /items/:id with DELETE' do
    login_as :jordan
    running {
      delete :destroy, :id=>items(:pizza)
      response.should redirect_to(items_path)
    }.should change(Item, :count).by(-1)
  end
  
end