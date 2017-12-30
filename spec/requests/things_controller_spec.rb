require 'rails_helper'

describe ThingsController, 'without logging in' do
  it 'handles / with GET' do
    gt root_path
    expect(response).to redirect_to(new_session_path)
  end
end

describe ThingsController do
  before { login_as :default }

  it 'handles / with GET' do
    gt root_path
    expect(response).to be_success
  end

  it 'handles /things/new with GET' do
    gt [:new, :thing]
    expect(response).to be_success
  end

  it 'handles /things with note attributes and POST' do
    expect {
      pst things_path thing: 'a note'
      expect(response).to redirect_to(root_url)
    }.to change(Note, :count).by(1)
  end

  it 'handles /things with transaction attributes and PUT' do
    expect {
      pst things_path, thing: '$5 Red Rock'
      expect(assigns(:thing).household).to eq(households(:default))
      expect(response).to redirect_to(root_url)
    }.to change(Transaction, :count).by(1)
  end

  it 'handles /things with run attributes and PUT' do
    expect {
      pst things_path, thing: 'Ran 2 20'
      expect(response).to redirect_to(root_url)
    }.to change(Workout, :count).by(1)
  end

end
