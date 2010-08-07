require 'spec_helper'

describe Bike do
  before { @bike = bikes(:default) }
    
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @bike.user.should == users(:default)
  end
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should find by day' do
    Bike.should have(1).on(Date.new(2008, 1, 1))
  end
    
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a user' do
    Bike.new.should have(1).error_on(:user_id)
  end
  
  it 'should have a date' do
    Bike.new.should have(1).error_on(:date)
  end

end