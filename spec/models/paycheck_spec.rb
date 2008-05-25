require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Paycheck, 'relationships' do
  
  before(:each) do
    @paycheck = paychecks(:last_week)
  end
  
  it 'should belong to a user' do
    @paycheck.item.should == items(:starbucks)
  end
  
  it 'should belong to a job' do
    @paycheck.job.should == jobs(:starbucks)
  end
  
  it 'should have many tasks' do
    @paycheck.tasks.should == [tasks(:today_shift)]
  end
end

#####################################################################
#                               S C O P E                           #
#####################################################################
describe Paycheck, 'scope' do
  it 'should find unpaid' do
    Paycheck.unpaid.should == [paychecks(:april)]
  end
end

#####################################################################
#                    O B J E C T    M E T H O D S                   #
#####################################################################
describe Paycheck do
  
  it 'should have a paid? attrbute' do
    paychecks(:april).should_not be_paid
    paychecks(:last_week).should be_paid
  end
  
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Paycheck, 'validations' do
  
  it 'should have a job_id' do
    Paycheck.new.should have(1).error_on(:job_id)
  end
  
  it 'should have a numeric value' do
    Paycheck.new(:value=>'asdf').should have(1).error_on(:value)
  end
  
  it 'should have an item and job belong to same person' do
    paycheck = paychecks(:april)
    paycheck.item = items(:starbucks)
    paycheck.should have(1).error_on(:item)
  end
end

#####################################################################
#                       D E S T R U C T I O N                       #
#####################################################################
describe Paycheck, 'destruction' do
  
  it 'should nullify tasks' do
    paychecks(:last_week).destroy
    tasks(:today_shift).paycheck.should be_nil
  end
  
end