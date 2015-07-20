require 'rails_helper'

describe Paycheck do
  before do
    @paycheck = paychecks(:default)
  end
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    expect(@paycheck.item).to eq(items(:default))
  end

  it 'should belong to a job' do
    expect(@paycheck.job).to eq(jobs(:default))
  end

  it 'should have many tasks' do
    expect(@paycheck.tasks.size).to eq(4)
  end

  #####################################################################
  #                               S C O P E                           #
  #####################################################################
  it 'should find unpaid' do
    expect(Paycheck.unpaid.size).to eq(1)
  end

  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  it 'should have a paid? attribute based on item' do
    expect(Paycheck.new).not_to be_paid
    expect(@paycheck).to be_paid
  end

  it 'should set paid attribute with boolean' do
    paycheck = Paycheck.new paid: false
    expect(paycheck).not_to be_paid
    paycheck.paid = true
    expect(paycheck).to be_paid
  end

  it 'should set paid attribute with an integer (a la form set)' do
    paycheck = Paycheck.new paid: 0
    expect(paycheck).not_to be_paid
    paycheck.paid = 1
    expect(paycheck).to be_paid
  end

  it 'should create an item on save if paid is set and no previous item' do
    paycheck = paychecks(:unpaid)
    paycheck.paid = true
    expect(running {
      paycheck.save
      expect(paycheck.item(true)).not_to be_nil
    }).to change(Item, :count).by(1)
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should have a job_id' do
    expect(Paycheck.new).to have(1).error_on(:job_id)
  end

  it 'should have a numeric value' do
    expect(Paycheck.new(value: 'not numeric')).to have(1).error_on(:value)
  end

  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should nullify tasks' do
    @paycheck.destroy
    expect(@paycheck.tasks(true)).to be_empty
  end
end