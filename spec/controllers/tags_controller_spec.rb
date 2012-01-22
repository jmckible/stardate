require File.dirname(__FILE__) + '/../spec_helper'

describe TagsController do
  before { login_as :default }
  
  it 'handles /tags with GET' do
    get :index
    response.should be_success
  end
  
  # it 'handles /tags/:id with GET' do
  #   get :show, id: tags(:default).to_param
  #   response.should be_success
  # end
  
end