require File.dirname(__FILE__) + '/../spec_helper'

describe RecurringsController do
  define_models
  before { login_as :default }
  
  it 'handles /recurrings with GET' do
    get :index
    response.should be_success
  end
  
  it 'handles /recurrings/new with GET' do
    get :new
    response.should be_success
  end
  
end