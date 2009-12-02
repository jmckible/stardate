require 'spec_helper'

describe Vendor, 'relationships' do
  before { @vendor = vendors(:default) }
  
  it 'should have many items' do
    @vendor.should have(2).items
  end
  
  it 'should find items from a user' do
    @vendor.items.from(users(:default)).size.should == 1
  end
  
  it 'should count items from a user' do
    @vendor.items.count_from(users(:default)).should == 1
  end
  
  it 'should sum items from a user' do
    @vendor.items.sum_from(users(:default)).should == -10
  end
  
end

describe Vendor, 'validations' do
  it 'should have a name' do
    Vendor.new.should have(1).error_on(:name)
  end
  
  it 'should have a unique name' do
    vendor = vendors(:default).clone
    vendor.should have(1).error_on(:name)
  end
end