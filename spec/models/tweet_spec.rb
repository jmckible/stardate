require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tweet do
  before { @tweet = tweets(:default) }
    
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @tweet.user.should == users(:default)
  end
   
  #####################################################################
  #                          A U T O L I N K                          #
  #####################################################################
  it 'should autolink text' do
    @tweet.autolink_text.should == 'A <a href="http://twitter.com/tweet">@tweet</a> <a href="http://www.test.com/something">http://www.test.com/something</a> okay'
  end
    
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a user' do
    Tweet.new.should have(1).error_on(:user_id)
  end

end
