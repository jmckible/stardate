require 'spec_helper'

describe Vendor, 'relationships' do
  it 'should have many items' do
    vendors(:default).should have(2).items
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