require File.dirname(__FILE__) + '/../spec_helper'

describe GraphsController do
  before do
    login_as :default 
    @request.env['HTTP_ACCEPT'] = 'application/xml'
  end
  
  it 'handles /graphs/running_month with GET' do
    get :running_month
    response.should be_success
  end
  
  it 'handles /graphs/running/:year with GET' do
    get :running_year
    response.should be_success
  end
  
  it 'handles /graphs/spending_month with GET' do
    get :spending_month
    response.should be_success
  end
  
  it 'handles /graphs/spending/:year with GET' do
    get :spending_year
    response.should be_success
  end
  
end