require 'rails_helper'

describe Weight, 'relationships' do
  it 'should belong to a user' do
    expect(weights(:default).user).to eq(users(:default))
  end
end

describe Weight, 'scopes' do
  it 'should find by day' do
    expect(Weight.on(Date.new(2008, 1, 1)).size).to eq(1)
  end
end

describe Weight, 'validations' do
  it 'should have a date' do
    expect(Weight.new).to have(1).error_on(:date)
  end

  it 'should have a user_id' do
    expect(Weight.new).to have(1).error_on(:user_id)
  end
end
