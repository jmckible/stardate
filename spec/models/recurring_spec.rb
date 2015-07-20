require 'rails_helper'

describe Recurring do
  before { @recurring = recurrings(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    expect(@recurring.user).to eq(users(:default))
  end

  it 'should belong to a vendor' do
    expect(@recurring.vendor).to eq(vendors(:default))
  end
  
  it 'should have many items' do
    expect(recurrings(:last).items.size).to eq(1)
  end

  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should have a during scope' do
    expect(Recurring.on(1).size).to eq(1)
    expect(Recurring.on(Date.new(2008, 1, 1)).size).to eq(1)
    expect(Recurring.on(Date.new(2007, 2, 28)).size).to eq(1)
  end
  
  #####################################################################
  #                           M E T H O D S                           #
  #####################################################################
  it 'should convert to a new item' do
    item = recurrings(:default).to_item
    expect(item.date).to eq(Date.today)
    expect(item.value).to eq(-100)
    expect(item.user).to eq(users(:default))
    expect(item.description).to eq('Recurring')
    expect(item.vendor).to eq(vendors(:default))
    expect(item.recurring).to eq(recurrings(:default))
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should have a user_id' do
    expect(Recurring.new).to have(1).error_on(:user_id)
  end
  
  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should nullify items on destroy' do
    recurrings(:last).destroy
    expect(items(:other).recurring).to be_nil
  end
  
end

