require 'spec_helper'

describe P90x do
  before { @p90x = p90xes(:default) }
    
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @p90x.user.should == users(:default)
  end
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should find by day' do
    P90x.should have(1).on(Date.new(2008, 1, 1))
  end
    
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a user' do
    P90x.new.should have(1).error_on(:user_id)
  end
  
  it 'should have a date' do
    P90x.new.should have(1).error_on(:date)
  end

end