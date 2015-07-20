require 'rails_helper'

describe User do
  before { @user = users(:default) }

  it 'should not authenticate an nil email' do
    expect(User.authenticate(nil, 'password')).to be_nil
  end

  it 'should not authenticate a blank password' do
    expect(User.authenticate('default@email.com', '')).to be_nil
  end

  it 'should authenticate a valid email/password pair' do
    expect(User.authenticate('default@email.com', 'test')).to eq(@user)
  end

  it 'should not authenticate an invalid email/password pair' do
    expect(User.authenticate('default@email.com', 'invalid')).to be_nil
  end

  it 'should encrypt password on save' do
    user = User.create name: 'name', email: 'new@user.com',
          household: households(:default),
          time_zone: 'Pacific Time (US & Canada)',
          password: 'password', password_confirmation: 'password'
    expect(user.password_hash).not_to be_blank
    expect(user.password_salt).not_to be_blank
  end

end
