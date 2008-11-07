require File.dirname(__FILE__) + '/../spec_helper'

describe ThingsController do
  define_models
  before { login_as :default }
  
  it 'handles /things with note attributes' do
    running {
      post :create, :thing=>'a note'
      response.should redirect_to(root_url)
    }.should change(Note, :count).by(1)
  end
  
  it 'handles /things with item attributes' do
    running {
      post :create, :thing=>'$5 Red Rock'
      response.should redirect_to(root_url)
    }.should change(Item, :count).by(1)
  end
  
end