require File.dirname(__FILE__) + '/../spec_helper'

describe ItemsController do
  define_models
  before do
    login_as :default
    @item = items(:default)
  end
  
  it 'handles /items with GET' do
    get :index
    assigns(:period).first.should == Date.new(Date.today.year, Date.today.month, 1)
    assigns(:period).last.should == Date.civil(Date.today.year, Date.today.month, -1)
    response.should be_success
  end
  
  it 'handles /items?date[month]=:month&date[year]=:year with GET' do
    get :index, :date=>{:month=>7, :year=>1999}
    assigns(:period).first.should == Date.new(1999, 7, 1)
    assigns(:period).last.should == Date.new(1999, 7, 31)
    response.should be_success
  end
  
  it 'handles /items/:id with GET' do
    get :show, :id=>@item
    response.should be_success
  end

  it 'handles /items/:id with valid params and PUT' do
    put :update, :id=>@item, :item=>{:description=>'new', :vendor_name=>vendors(:other).name}
    @item.reload.description.should == 'new'
    @item.vendor.should == vendors(:other)
    response.should redirect_to(root_path)
  end
  
  it 'handles /items/:id with emptying of vendor and PUT' do
    put :update, :id=>@item, :item=>{:description=>'new', :vendor_name=>'' }
    @item.reload.description.should == 'new'
    @item.vendor.should be_nil
    response.should redirect_to(root_path)
  end

  it 'handles /items/:id with DELETE' do
    running {
      delete :destroy, :id=>@item
      response.should redirect_to(root_path)
    }.should change(Item, :count).by(-1)
  end
  
end