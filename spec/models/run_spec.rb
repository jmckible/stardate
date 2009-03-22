require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Run do
  before { @run = runs(:default) }
    
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @run.user.should == users(:default)
  end
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should find by day' do
    Run.should have(1).on(Date.new(2008, 1, 1))
  end
    
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a user' do
    Run.new.should have(1).error_on(:user_id)
  end
  
  it 'should have a date' do
    Run.new.should have(1).error_on(:date)
  end

end