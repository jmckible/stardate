require File.dirname(__FILE__) + '/../spec_helper'

describe Recurring do
  define_models
  before { @recurring = recurrings(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @recurring.user.should == users(:default)
  end

  it 'should belong to a vendor' do
    @recurring.vendor.should == vendors(:default)
  end

  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should have a during scope' do
    Recurring.should have(1).on(1)
    Recurring.should have(1).on(Date.new(2008, 1, 1))
    Recurring.should have(1).on(Date.new(2007, 2, 28))
  end
  
  #####################################################################
  #                           M E T H O D S                           #
  #####################################################################
  it 'should convert to a new item' do
    item = recurrings(:default).to_item
    item.date.should == Date.today
    item.value.should == -100
    item.user.should == users(:default)
    item.description.should == 'Recurring'
    item.vendor.should == vendors(:default)
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should have a user_id' do
    Recurring.new.should have(1).error_on(:user_id)
  end
  
end

