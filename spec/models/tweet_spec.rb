require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tweet do
  define_models
  before { @tweet = tweets(:default) }
    
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @tweet.user.should == users(:default)
  end
    
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a user' do
    Tweet.new.should have(1).error_on(:user_id)
  end

end
