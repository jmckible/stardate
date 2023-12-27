require 'rails_helper'

describe SessionsController do

  it 'handles /sessions/new with GET' do
    gt [:new, :session]
    expect(response).to be_successful
  end

  it 'redirects to root path on request to /sessions/new with logged in user and GET' do
    login_as :default
    gt [:new, :session]
    expect(response).to redirect_to(root_path)
  end

  it 'logs in a user with valid credentials' do
    @user = users(:default)
    pst sessions_path, email: @user.email, password: 'test'
    expect(response).to redirect_to(root_path)
    expect(session[:user_id]).to eq(@user.id)
  end

  it 'denies access to a user with invalid credentials' do
    pst sessions_path
    expect(response).to redirect_to(new_session_path)
  end

  it 'logs out a user' do
    login_as :default
    del session_path(@current_user)
    expect(response).to redirect_to(new_session_path)
    expect(session[:user_id]).to be_nil
  end

end
