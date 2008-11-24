require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do
  define_models
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
    Run.should have(1).on(current_time.to_date)
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