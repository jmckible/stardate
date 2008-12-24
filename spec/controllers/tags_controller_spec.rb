require File.dirname(__FILE__) + '/../spec_helper'

describe TagsController do
  define_models
  before { login_as :default }
  
  it 'handles /tags with GET' do
    get :index
    response.should be_success
  end
  
end