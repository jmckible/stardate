require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Note do
  define_models
  before { @note = notes(:default) }
  
  it 'should belong to a user' do
    @note.user.should == users(:default)
  end
  
  it 'should have a body' do
    Note.new.should have(1).error_on(:body)
  end
  
  it 'should have a date' do
    Note.new.should have(1).error_on(:date)
  end
  
  it 'should belong to a user' do
    Note.new.should have(1).error_on(:user_id)
  end
end
