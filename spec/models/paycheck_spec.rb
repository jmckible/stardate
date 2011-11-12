require 'spec_helper'

describe Paycheck do
  before do
    @paycheck    = paychecks(:default)
    @unpaid      = @paycheck.clone
    @unpaid.item = nil
    @unpaid.save
  end
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @paycheck.item.should == items(:default)
  end

  it 'should belong to a job' do
    @paycheck.job.should == jobs(:default)
  end

  it 'should have many tasks' do
    @paycheck.should have(4).tasks
  end

  #####################################################################
  #                               S C O P E                           #
  #####################################################################
  it 'should find unpaid' do
    Paycheck.should have(1).unpaid
  end

  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  it 'should have a paid? attribute based on item' do
    @unpaid.should_not be_paid
    @paycheck.should be_paid
  end

  it 'should set paid attribute with boolean' do
    paycheck = Paycheck.new :paid=>false
    paycheck.should_not be_paid
    paycheck.paid = true
    paycheck.should be_paid
  end

  it 'should set paid attribute with an integer (a la form set)' do
    paycheck = Paycheck.new :paid=>0
    paycheck.should_not be_paid
    paycheck.paid = 1
    paycheck.should be_paid
  end

  it 'should create an item on save if paid is set and no previous item' do
    @unpaid.paid = true
    running {
      @unpaid.save
      @unpaid.item(true).should_not be_nil
    }.should change(Item, :count).by(1)
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should have a job_id' do
    Paycheck.new.should have(1).error_on(:job_id)
  end

  it 'should have a numeric value' do
    Paycheck.new(:value=>'not numeric').should have(1).error_on(:value)
  end

  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should nullify tasks' do
    @paycheck.destroy
    @paycheck.tasks(true).should be_empty
  end
end