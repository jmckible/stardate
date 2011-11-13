require 'spec_helper'

describe User do
  before { @user = users(:default) }
  
  #####################################################################
  #                      C L A S S     M E T H O D S                  #
  #####################################################################
  it 'should not authenticate an nil email' do
    User.authenticate(nil, 'password').should be_nil
  end

  it 'should not authenticate a blank password' do
    User.authenticate('default@email.com', '').should be_nil
  end

  it 'should authenticate a valid email/password pair' do
    User.authenticate('default@email.com', 'test').should == @user
  end

  it 'should not authenticate an invalid email/password pair' do
    User.authenticate('default@email.com', 'invalid').should be_nil
  end

  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should have many bikes' do
    @user.should have(1).bikes
  end
  
  it 'should have many ellipticals' do
    @user.should have(1).ellipticals
  end
  
  it 'should have many items' do
    @user.should have(1).items
  end

  it 'should have many jobs' do
    @user.should have(1).jobs
  end
  
  it 'should have many notes' do
    @user.should have(1).notes
  end

  it 'should have many recurrings' do
    @user.should have(1).recurrings
  end
  
  it 'should have many runs' do
    @user.should have(1).runs
  end
  
  it 'should have many nikes' do
    @user.should have(1).nikes
  end

  it 'should have many tasks' do
    @user.should have(3).tasks
  end
  
  it 'should have many vendors' do
    @user.should have(1).vendors
  end
  
  it 'should have many weights' do
    @user.should have(1).weights
  end

  #####################################################################
  #                        C A L L B A C K S                          #
  #####################################################################
  it 'should encrypt password on save' do
    user = User.create :email=>'new@user.com', :time_zone=>'Pacific Time (US & Canada)',
          :password=>'password', :password_confirmation=>'password'
    user.password_hash.should_not be_blank
    user.password_salt.should_not be_blank
  end

  #####################################################################
  #                      V A L I D A T I O N S                        #
  #####################################################################
  it 'should require password confirmation' do
    user = User.new :password=>'test'
    user.should have(1).error_on(:password_confirmation)
  end

  it 'should have at least a 4 char password' do
    user = User.new :password=>'cat'
    user.should have(1).error_on(:password)
  end

  it 'should have a valid email address' do
    user = User.new :email=>'invalid'
    user.should have(1).error_on(:email)
  end

  it 'should have a unique email' do
    user = User.new email: @user.email
    user.should have(1).error_on(:email)
  end

  it 'should have a time zone' do
    User.new.should have(1).error_on(:time_zone)
  end

  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should delete bikes on destroy' do
    running { @user.destroy }.should change(Bike, :count).by(-1)
  end
  
  it 'should delete ellipticals on destroy' do
    running { @user.destroy }.should change(Elliptical, :count).by(-1)
  end
  
  it 'should delete items on destroy' do
    running { @user.destroy }.should change(Item, :count).by(-1)
  end

  it 'should delete jobs on destroy' do
    running { @user.destroy }.should change(Job, :count).by(-1)
  end
  
  it 'should delete notes on destroy' do
    running { @user.destroy }.should change(Note, :count).by(-1)
  end

  it 'should delete recurrings on destroy' do
    running { @user.destroy }.should change(Recurring, :count).by(-1)
  end
  
  it 'should delete weights on destroy' do
    running { @user.destroy }.should change(Weight, :count).by(-1)
  end
  
end