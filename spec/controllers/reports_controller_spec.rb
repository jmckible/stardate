require File.dirname(__FILE__) + '/../spec_helper'

describe ReportsController do
  before { login_as :default }
  
  it 'handles /reports with GET' do
    get :index
    response.should be_success
  end
  
end