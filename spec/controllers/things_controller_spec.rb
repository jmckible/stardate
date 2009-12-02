require 'spec_helper'

describe ItemsController, 'without logging in' do
  it 'handles / with GET' do
    get :index
    response.should redirect_to(new_session_path)
  end
end

describe ThingsController do
  before { login_as :default }
  
  it 'handles / with GET' do
    get :index
    response.should be_success
  end
  
  it 'handles /things/new with GET' do
    get :new
    response.should be_success
  end
  
  it 'handles /things with note attributes and PUT' do
    running {
      post :create, :thing=>'a note'
      response.should redirect_to(root_url)
    }.should change(Note, :count).by(1)
  end
  
  it 'handles /things with item attributes and PUT' do
    running {
      post :create, :thing=>'$5 Red Rock'
      response.should redirect_to(root_url)
    }.should change(Item, :count).by(1)
  end
  
  it 'handles /things with run attributes and PUT' do
    running {
      post :create, :thing=>'Ran 2'
      response.should redirect_to(root_url)
    }.should change(Run, :count).by(1)
  end
  
end