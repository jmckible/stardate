require File.dirname(__FILE__) + '/../spec_helper'

describe Task do
  define_models
  before { @task = tasks(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a job' do
    @task.job.should == jobs(:default)
  end

  it 'should belong to a paycheck' do
    @task.paycheck.should == paychecks(:default)
  end

  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should find by day' do
    Task.should have(4).on(current_time.to_date)
  end

  it 'should find unpaid' do
    Task.should have(0).unpaid
  end

  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  it 'should derive hours and min with null minutes' do
    task = Task.new
    task.hours.should be_nil
    task.min.should == '00'
  end

  it 'should derive hours and min with less than 60 minutes' do
    task = tasks(:short)
    task.hours.should be_nil
    task.min.should == 30
  end

  it 'should derive hours and min with more than 60 minutes' do
    task = tasks(:long)
    task.hours.should == 2
    task.min.should == '00'
  end

  it 'should over write just hours' do
    task = tasks(:short)
    task.hours = 2
    task.save
    task.reload
    task.minutes.should == 120
  end

  it 'should overwrite hours and min' do
    task = tasks(:short)
    task.hours = 1
    task.min = 20
    task.save
    task.reload
    task.minutes.should == 80
  end

  it 'should overwrite just minutes' do
    task = tasks(:long)
    task.min = 40
    task.save
    task.reload
    task.minutes.should == 40
  end

  it 'should set hours and min for a new task' do
    task = Task.create:date=>Date.today, :job=>jobs(:default), :hours=>1, :min=>20
    task.minutes.should == 80
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a job' do
    Task.new.should have(1).error_on(:job_id)
  end

  it 'should have a date' do
    Task.new.should have(1).error_on(:date)
  end

  it 'should not have a paycheck from the same job' do
    task = tasks(:other)
    task.paycheck = paychecks(:default)
    task.should have(1).error_on(:paycheck)
  end
end