require 'spec_helper'

describe Weight, 'relationships' do
  it 'should belong to a user' do
    weights(:default).user.should == users(:default)
  end
end

describe Weight, 'scopes' do
  it 'should find by day' do
    Weight.should have(1).on(Date.new(2008, 1, 1))
  end
end

describe Weight, 'validations' do
  it 'should have a date' do
    Weight.new.should have(1).error_on(:date)
  end
  
  it 'should have a user_id' do
    Weight.new.should have(1).error_on(:user_id)
  end
end
