require 'rails_helper'

describe VendorsController do
  before { login_as :default }

  it 'handles /vendors with GET' do
    gt vendors_path
    expect(response).to be_success
  end

  it 'handles /vendors/:id with GET' do
    gt vendors(:default)
    expect(response).to be_success
  end

end
