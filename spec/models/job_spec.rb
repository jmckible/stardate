require File.dirname(__FILE__) + '/../spec_helper'

describe Job do
  define_models
  before { @job = jobs(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @job.user.should == users(:default)
  end

  it 'should have many paychecks' do
    @job.should have(1).paychecks
  end

  it 'should have many tasks' do
    @job.should have(3).tasks
  end

  it 'should belong to a vendor' do
    @job.vendor.should == vendors(:default)
  end

  #####################################################################
  #                               S C O P E                           #
  #####################################################################
  it 'should find active' do
    Job.should have(2).active
  end

  #####################################################################
  #                         P R O T E C T I O N                       #
  #####################################################################
  it 'should not update user_id through mass assignment' do
    @job.update_attributes :user_id=>users(:other).id
    @job.user_id.should_not == users(:other).id
  end

  it 'should not update user through mass assignment' do
    @job.update_attributes :user=>users(:other)
    @job.user(true).should_not == users(:other)
  end
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should have a name' do
    Job.new.should have(1).error_on(:name)
  end

  it 'should have a user_id' do
    Job.new.should have(1).error_on(:user_id)
  end

  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should destroy paychecks' do
    running { @job.destroy }.should change(Paycheck, :count).by(-1)
  end

  it 'should destroy tasks' do
    running { @job.destroy }.should change(Task, :count).by(-3)
  end
end
