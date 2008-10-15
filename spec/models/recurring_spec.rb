require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Recurring, 'relationships' do 
  it 'should belong to a user' do
    recurrings(:rent).user.should == users(:jordan)
  end
  
  it 'should belong to a vendor' do
    recurrings(:ing).vendor.should == vendors(:ing)
  end
end

#####################################################################
#                            S C O P E                              #
#####################################################################
describe Recurring, 'scope' do
  it 'should have a during scope' do
    Recurring.should have(1).on(1)
    Recurring.should have(1).on(Date.new(2008, 1, 1))
  end
end

#####################################################################
#                    O B J E C T    M E T H O D S                   #
#####################################################################
describe Recurring do
  
  before(:each) do
    @recurring = recurrings(:rent)
  end
  
  it 'should have a string value with explicit plus sign' do
    @recurring.string_value.should == '-750'
    recurrings(:ing).string_value.should == '+100'
  end
  
  it 'should round values and assume negative' do
    @recurring.value = 12.99
    @recurring.save
    @recurring.value.should == -13
  end
  
  it 'should use plus sign for explicit positive' do
    @recurring.value = '+4.50'
    @recurring.save
    @recurring.value.should == 5
  end  
  
  it 'should handle zero value properly' do
    @recurring.value = 0
    @recurring.save
    @recurring.value.should == 0
  end
end

#####################################################################
#                         P R O T E C T I O N                       #
#####################################################################
describe Recurring, 'protections' do
  
  before(:each) do
    @recurring = recurrings(:rent)
  end
  
  it 'should not update user_id through mass assignment' do
    @recurring.update_attributes :user_id=>users(:scott).id
    @recurring.user_id.should_not == users(:scott).id
  end
  
  it 'should not update user through mass assignment' do
    @recurring.update_attributes :user=>users(:scott)
    @recurring.user.should_not == users(:scott)
  end
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Recurring, 'validations' do
  
  it 'should have a user_id' do
    Recurring.new.should have(1).error_on(:user_id)
  end
end