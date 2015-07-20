require 'rails_helper'

describe VendorsController do
  before { login_as :default }
  
  it 'handles /vendors with GET' do
    get :index
    expect(response).to be_success
  end
  
  it 'handles /vendors/:id with GET' do
    get :show, id: vendors(:default)
    expect(response).to be_success
  end
  
end