require 'rails_helper'

# describe transactionsController, 'without logging in' do
#   it 'handles / with GET' do
#     get :index
#     response.should redirect_to(new_session_path)
#   end
# end

describe ThingsController do
  before { login_as :default }

  it 'handles / with GET' do
    get :index
    expect(response).to be_success
  end

  it 'handles /things/new with GET' do
    get :new
    expect(response).to be_success
  end

  it 'handles /things with note attributes and PUT' do
    expect(running {
      post :create, :thing=>'a note'
      expect(response).to redirect_to(root_url)
    }).to change(Note, :count).by(1)
  end

  it 'handles /things with transaction attributes and PUT' do
    expect(running {
      post :create, :thing=>'$5 Red Rock'
      expect(assigns(:thing).household).to eq(households(:default))
      expect(response).to redirect_to(root_url)
    }).to change(Transaction, :count).by(1)
  end

  it 'handles /things with run attributes and PUT' do
    expect(running {
      post :create, :thing=>'Ran 2'
      expect(response).to redirect_to(root_url)
    }).to change(Workout, :count).by(1)
  end

end
