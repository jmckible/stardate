# require 'rails_helper'
#
# describe transactionsController do
#   before do
#     login_as :default
#     @transaction = transactions(:default)
#   end
#
#   it 'handles /transactions with GET' do
#     get :index
#     assigns(:period).first.should == Date.new(Date.today.year, Date.today.month, 1)
#     assigns(:period).last.should == Date.civil(Date.today.year, Date.today.month, -1)
#     response.should be_success
#   end
#
#   it 'handles /transactions?date[month]=:month&date[year]=:year with GET' do
#     get :index, :date=>{:month=>7, :year=>1999}
#     assigns(:period).first.should == Date.new(1999, 7, 1)
#     assigns(:period).last.should == Date.new(1999, 7, 31)
#     response.should be_success
#   end
#
#   it 'handles /transactions/:id with GET' do
#     get :show, :id=>@transaction
#     response.should be_success
#   end
#
#   it 'handles /transactions/:id with valid params and PUT' do
#     put :update, :id=>@transaction, :transaction=>{:description=>'new', :vendor_name=>vendors(:other).name}
#     @transaction.reload.description.should == 'new'
#     @transaction.vendor.should == vendors(:other)
#     response.should redirect_to(root_path)
#   end
#
#   it 'handles /transactions/:id with emptying of vendor and PUT' do
#     put :update, :id=>@transaction, :transaction=>{:description=>'new', :vendor_name=>'' }
#     @transaction.reload.description.should == 'new'
#     @transaction.vendor.should be_nil
#     response.should redirect_to(root_path)
#   end
#
#   it 'handles /transactions/:id with DELETE' do
#     running {
#       delete :destroy, :id=>@transaction
#       response.should redirect_to(root_path)
#     }.should change(transaction, :count).by(-1)
#   end
#
# end
