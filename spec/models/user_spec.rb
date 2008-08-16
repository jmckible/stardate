require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                      C L A S S     M E T H O D S                  #
#####################################################################
describe User, 'authentication' do
  it 'should not authenticate an nil email' do
    User.authenticate(nil, 'password').should be_nil
  end
  
  it 'should not authenticate a blank password' do
    User.authenticate('jordan@test.com', '').should be_nil
  end
  
  it 'should authenticate a valid email/password pair' do
    User.authenticate('jordan@test.com', 'test').should == users(:jordan)
  end
  
  it 'should not authenticate an invalid email/password pair' do
    User.authenticate('jordan@test.com', 'invalid').should be_nil
  end
end

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe User, 'relationships' do
  before(:each) do
    @user = users(:jordan)
  end
  
  it 'should have many items' do
    @user.should have(6).items
  end
  
  it 'should have many jobs' do
    @user.should have(1).jobs
  end
  
  it 'should have many recurrings' do
    @user.should have(2).recurrings
  end
  
  it 'should have many tasks' do
    @user.should have(2).tasks
  end
end

#####################################################################
#                   O B J E C T S   M E T H O D S                  #
#####################################################################
describe User do
  before(:each) do
    @user = users(:jordan)
  end
  
  # activity_during?
  it 'should detect activity from a task' do
    @user.should be_activity_during(Date.today - 45)
  end
  
  it 'should detect activity from an item' do
    @user.should be_activity_during(Date.yesterday)
  end
  
  it 'should invert range for detecting activity' do
    @user.should be_activity_during(Date.tomorrow..Date.today)
  end
  
  it 'should fail to detect activity if none' do
    @user.should_not be_activity_during(Date.tomorrow)
  end
  
  # totaling
  it 'should total on a date' do
    @user.total_on(Date.today).should == 37
  end
  
  it 'should total for the week' do
    @user.total_this_week.should == 1
  end
  
  it 'should total this month' do
    @user.total_this_month.should == -749
  end
  
  it 'should total this year' do
    @user.total_this_year.should == -449
  end


  # summing
  it 'should sum income from a range' do
    @user.sum_income((Date.today - 60)..Date.today).should == 100
  end
  
  it 'should sum income from a date' do
    @user.sum_income(Date.today).should == 0
  end
  
  it 'should sum expenses from a range' do
    @user.sum_expenses((Date.today - 30)..Date.today).should == -799
  end
  
  it 'should sum expenses from a date' do
    @user.sum_expenses(Date.today).should == -13
  end
  
  
  # value unpaid
  it 'should value unpaid tasks with date' do
    @user.value_unpaid_tasks_on(Date.today).should == 50
  end
  
  it 'should value unpaid tasks with a range and a paid' do
    @user.value_unpaid_tasks_on((Date.today - 60)..Date.today).should == 250
  end
end

#####################################################################
#                        C A L L B A C K S                          #
#####################################################################
describe User, 'callbacks' do
  it 'should encrypt password on save' do
    user = User.create :email=>'new@user.com', :time_zone=>'Pacific Time (US & Canada)',
          :password=>'password', :password_confirmation=>'password'
    user.password_hash.should_not be_blank
    user.password_salt.should_not be_blank
  end
end

#####################################################################
#                      V A L I D A T I O N S                        #
#####################################################################
describe User, 'validations' do
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
    user = users(:jordan).clone
    user.should have(1).error_on(:email)
  end
  
  it 'should have a time zone' do
    User.new.should have(1).error_on(:time_zone)
  end
end

#####################################################################
#                       P R O T E C T I O N                         #
#####################################################################
describe User, 'protections' do
  before(:each) do
    @user = users(:jordan)
  end
  
  it 'should not update password hash through mass assignment' do
    @user.update_attributes :password_hash=>'new hash'
    @user.reload.password_hash.should_not == 'new hash'
  end
  
  it 'should not update password salt through mass assignment' do
    @user.update_attributes :password_salt=>'new salt'
    @user.reload.password_salt.should_not == 'new salt'
  end
  
  it 'should not update created at through mass assignment' do
    @user.update_attributes :created_at=>2.weeks.ago
    @user.reload.created_at.should > 2.weeks.ago
  end
end

#####################################################################
#                       D E S T R U C T I O N                       #
#####################################################################
describe User, 'destruction' do
  before(:each) do
    @user = users(:jordan)
  end
  
  it 'should delete items on destroy' do
    running { @user.destroy }.should change(Item, :count).by(-6)
  end
  
  it 'should delete jobs on destroy' do
    running { @user.destroy }.should change(Job, :count).by(-1)
  end
  
  it 'should delete recurrings on destroy' do
    running { @user.destroy }.should change(Recurring, :count).by(-2)
  end
end