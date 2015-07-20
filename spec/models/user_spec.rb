require 'rails_helper'

describe User do
  before { @user = users(:default) }
  
  #####################################################################
  #                      C L A S S     M E T H O D S                  #
  #####################################################################
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

  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should have many items' do
    expect(@user.items.size).to eq(1)
  end

  it 'should have many jobs' do
    expect(@user.jobs.size).to eq(1)
  end
  
  it 'should have many notes' do
    expect(@user.notes.size).to eq(1)
  end

  it 'should have many recurrings' do
    expect(@user.recurrings.size).to eq(1)
  end
  
  it 'should have many tasks' do
    expect(@user.tasks.size).to eq(3)
  end
  
  it 'should have many vendors' do
    expect(@user.vendors.size).to eq(1)
  end
  
  it 'should have many weights' do
    expect(@user.weights.size).to eq(1)
  end

  #####################################################################
  #                        C A L L B A C K S                          #
  #####################################################################
  it 'should encrypt password on save' do
    user = User.create name: 'name', email: 'new@user.com', 
          household: households(:default),
          time_zone: 'Pacific Time (US & Canada)',
          password: 'password', password_confirmation: 'password'
    expect(user.password_hash).not_to be_blank
    expect(user.password_salt).not_to be_blank
  end

  #####################################################################
  #                      V A L I D A T I O N S                        #
  #####################################################################
  it 'should require password confirmation' do
    user = User.new :password=>'test'
    expect(user).to have(1).error_on(:password_confirmation)
  end

  it 'should have at least a 4 char password' do
    user = User.new :password=>'cat'
    expect(user).to have(1).error_on(:password)
  end

  it 'should have a valid email address' do
    user = User.new :email=>'invalid'
    expect(user).to have(1).error_on(:email)
  end

  it 'should have a unique email' do
    user = User.new email: @user.email
    expect(user).to have(1).error_on(:email)
  end

  it 'should have a time zone' do
    expect(User.new).to have(1).error_on(:time_zone)
  end

  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should delete items on destroy' do
    expect(running { @user.destroy }).to change(Item, :count).by(-1)
  end

  it 'should delete jobs on destroy' do
    expect(running { @user.destroy }).to change(Job, :count).by(-1)
  end
  
  it 'should delete notes on destroy' do
    expect(running { @user.destroy }).to change(Note, :count).by(-1)
  end

  it 'should delete recurrings on destroy' do
    expect(running { @user.destroy }).to change(Recurring, :count).by(-1)
  end
  
  it 'should delete weights on destroy' do
    expect(running { @user.destroy }).to change(Weight, :count).by(-1)
  end
  
end