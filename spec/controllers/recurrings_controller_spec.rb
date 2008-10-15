require File.dirname(__FILE__) + '/../spec_helper'

describe RecurringsController do
  
  it 'handles /recurrings with GET' do
    login_as :jordan
    get :index
    response.should be_success
  end
  
end