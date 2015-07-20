require 'rails_helper'

describe Vendor, 'relationships' do
  it 'should have many items' do
    expect(vendors(:default).items.size).to eq(2)
  end
end

describe Vendor, 'validations' do
  it 'should have a name' do
    expect(Vendor.new).to have(1).error_on(:name)
  end
  
  it 'should have a unique name' do
    vendor = Vendor.new name: vendors(:default).name
    expect(vendor).to have(1).error_on(:name)
  end
end