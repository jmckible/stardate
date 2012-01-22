require File.dirname(__FILE__) + '/../spec_helper'

describe DateController do
  before { login_as :default }
  
  it 'handles /date/:year/:month/:day with valid date and GET' do
    get :show, year: 2008, month: 1, day: 1
    assigns(:date).should == Date.new(2008, 1, 1)
    response.should be_success
  end
  
  it 'handles /date/:year/:month/:day with invalid date and GET' do
    get :show, year: 2008, month: 2, day: 30
    response.response_code.should == 404
  end
  
end