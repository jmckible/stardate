require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Item, 'relationships' do 
  it 'should belong to a user' do
    items(:pizza).user.should == users(:jordan)
  end
  
  it 'should belong to a paycheck' do
    items(:starbucks_last_week).paycheck.should == paychecks(:starbucks_last_week)
  end
  
  it 'should belong to a vendor' do
    items(:pizza).vendor.should == vendors(:sals)
  end
end

#####################################################################
#                             T A G G I N G                         #
#####################################################################
describe Item, 'tagging' do
  
  before(:each) do
    @item = items(:pizza)
  end
  
  it 'should have many taggings' do
    @item.should have(2).taggings
  end
  
  it 'should have many tags alphabetically' do
    @item.tags.should == tags(:food, :pizza)
  end
  
  it 'should have a tag list' do
    @item.tag_list.should == 'food, pizza'
  end
  
  it 'should add a new tag via tag list' do
    running {
      running {
        @item.tag_list = 'pizza, food, cupcake'
        @item.save
        @item.reload.tag_list.should == 'cupcake, food, pizza'
      }.should change(Tag, :count).by(1) 
    }.should change(Tagging, :count).by(1)
  end
  
  it 'should empty tag list when nothing is passed' do
    running {
      @item.tag_list = ''
      @item.save
      @item.should have(0).tags
    }.should change(Tagging, :count).by(-2)
  end
end

#####################################################################
#                            S C O P E                              #
#####################################################################
describe Item, 'scope' do
  it 'should have a during scope' do
    Item.should have(3).on(Date.new(2008, 1, 15))
  end
end

#####################################################################
#                    O B J E C T    M E T H O D S                   #
#####################################################################
describe Item do
  
  before(:each) do
    @item = items(:pizza)
  end
  
  it 'should round values and assume negative' do
    @item.value = 12.99
    @item.save
    @item.value.should == -13
  end
  
  it 'should use plus sign for explicit positive' do
    @item.value = '+4.50'
    @item.save
    @item.value.should == 5
  end  
  
  it 'should handle zero value properly' do
    @item.value = 0
    @item.save
    @item.value.should == 0
  end
end

#####################################################################
#                         P R O T E C T I O N                       #
#####################################################################
describe Item, 'protections' do
  
  before(:each) do
    @item = items(:pizza)
  end
  
  it 'should not update user_id through mass assignment' do
    @item.update_attributes :user_id=>users(:scott).id
    @item.user_id.should_not == users(:scott).id
  end
  
  it 'should not update user through mass assignment' do
    @item.update_attributes :user=>users(:scott)
    @item.user.should_not == users(:scott)
  end
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Item, 'validations' do
  
  it 'should have a date' do
    Item.new.should have(1).error_on(:date)
  end
  
  it 'should have a user_id' do
    Item.new.should have(1).error_on(:user_id)
  end
end

#####################################################################
#                       D E S T R U C T I O N                       #
#####################################################################
describe Item, 'destruction' do
  
  it 'should nullify paycheck on destroy' do
    items(:starbucks_last_week).destroy
    paychecks(:starbucks_last_week).item.should be_nil
  end
end