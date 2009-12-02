require 'spec_helper'

describe VendorsController do
  before { login_as :default }
  
  it 'handles /vendors with GET' do
    get :index
    response.should be_success
  end
  
  it 'handles /vendors/:id with GET' do
    get :show, :id=>vendors(:default).to_param
    response.should be_success
  end
  
end