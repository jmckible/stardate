require File.dirname(__FILE__) + '/../spec_helper'

describe GraphsController do
  
  it 'handles /graphs/activity with GET' do
    login_as :jordan
    get :activity
    assigns(:period).should == ((Date.today - 30)..Date.today)
    response.should be_success
  end
  
end