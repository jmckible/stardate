require 'rails_helper'

describe TagsController do
  before { login_as :default }
  
  it 'handles /tags with GET' do
    get :index
    expect(response).to be_success
  end
  
  # it 'handles /tags/:id with GET' do
  #   get :show, id: tags(:default).to_param
  #   response.should be_success
  # end
  
end