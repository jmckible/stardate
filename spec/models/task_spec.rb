require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Task, 'relationships' do
  it 'should belong to a job' do
    tasks(:starbucks_one).job.should == jobs(:starbucks)
  end
  
  it 'should belong to a paycheck' do
    tasks(:starbucks_one).paycheck.should == paychecks(:starbucks_last_week)
  end
end

#####################################################################
#                            S C O P E                              #
#####################################################################
describe Task, 'scopes' do
  it 'should find by day' do
    Task.should have(2).on(Date.new(2008, 1, 15))
  end
  
  it 'should find unpaid' do
    Task.should have(1).unpaid
  end
end

#####################################################################
#                    O B J E C T    M E T H O D S                   #
#####################################################################
describe Task do
  
  it 'should derive hours and min with null minutes' do
    task = Task.new
    task.hours.should be_nil
    task.min.should == '00'
  end
  
  it 'should derive hours and min with less than 60 minutes' do
    task = tasks(:risi_reboot)
    task.hours.should be_nil
    task.min.should == 30
  end
  
  it 'should derive hours and min with more than 60 minutes' do
    task = tasks(:risi_dms)
    task.hours.should == 2
    task.min.should == '00'
  end
  
  it 'should over write just hours' do
    task = tasks(:risi_reboot)
    task.hours = 2
    task.save
    task.reload
    task.minutes.should == 120
  end
  
  it 'should overwrite hours and min' do
    task = tasks(:risi_reboot)
    task.hours = 1
    task.min = 20
    task.save
    task.reload
    task.minutes.should == 80
  end
  
  it 'should overwrite just minutes' do
    task = tasks(:risi_reboot)
    task.min = 40
    task.save
    task.reload
    task.minutes.should == 40
  end
  
  it 'should set hours and min for a new task' do
    task = Task.create:date=>Date.today, :job=>jobs(:risi), :hours=>1, :min=>20
    task.minutes.should == 80
  end
  
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Task, 'validations' do
  it 'should belong to a job' do
    Task.new.should have(1).error_on(:job_id)
  end
  
  it 'should have a date' do
    Task.new.should have(1).error_on(:date)
  end
  
  it 'should have a paycheck from the same job' do
    task = tasks(:risi_reboot)
    task.paycheck = paychecks(:starbucks_last_week)
    task.should have(1).error_on(:paycheck)
  end
end