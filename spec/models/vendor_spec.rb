require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vendor, 'validations' do
  it 'should have a name' do
    Vendor.new.should have(1).error_on(:name)
  end
  
  it 'should have a unique name' do
    vendor = vendors(:starbucks).clone
    vendor.should have(1).error_on(:name)
  end
end