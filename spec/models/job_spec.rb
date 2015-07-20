require 'rails_helper'

describe Job do
  before { @job = jobs(:default) }

  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    expect(@job.user).to eq(users(:default))
  end

  it 'should have many paychecks' do
    expect(@job.paychecks.size).to eq(2)
  end

  it 'should have many tasks' do
    expect(@job.tasks.size).to eq(3)
  end

  it 'should belong to a vendor' do
    expect(@job.vendor).to eq(vendors(:default))
  end

  #####################################################################
  #                               S C O P E                           #
  #####################################################################
  it 'should find active' do
    expect(Job.active.size).to eq(2)
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should have a name' do
    expect(Job.new).to have(1).error_on(:name)
  end

  it 'should have a user_id' do
    expect(Job.new).to have(1).error_on(:user_id)
  end

  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should destroy paychecks' do
    expect(running { @job.destroy }).to change(Paycheck, :count).by(-2)
  end

  it 'should destroy tasks' do
    expect(running { @job.destroy }).to change(Task, :count).by(-3)
  end
end
