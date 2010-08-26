require 'spec_helper'

describe Elliptical do
  before { @elliptical = ellipticals(:default) }
    
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @elliptical.user.should == users(:default)
  end
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should find by day' do
    Elliptical.should have(1).on(Date.new(2008, 1, 1))
  end
    
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a user' do
    Elliptical.new.should have(1).error_on(:user_id)
  end
  
  it 'should have a date' do
    Elliptical.new.should have(1).error_on(:date)
  end

end