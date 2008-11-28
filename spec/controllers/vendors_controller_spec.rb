require File.dirname(__FILE__) + '/../spec_helper'

describe VendorsController do
  define_models
  before { login_as :default }
  
  it 'handles /vendors with GET' do
    get :index
    response.should be_success
  end
  
end