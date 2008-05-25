require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Item, 'relationships' do 
   
  before(:each) do
    @item = items(:sals)
  end
  
  it 'should belong to a user' do
    @item.user.should == users(:jordan)
  end
  
  it 'should belong to a paycheck' do
    items(:starbucks).paycheck.should == paychecks(:last_week)
  end  
end

#####################################################################
#                             T A G G I N G                         #
#####################################################################
describe Item, 'tagging' do
  
  before(:each) do
    @item = items(:sals)
  end
  
  it 'should have many taggings' do
    @item.taggings.should == taggings(:sals_pizza, :sals_sals)
  end
  
  it 'should have many tags' do
    @item.tags.should == tags(:pizza, :sals)
  end
  
  it 'should have a tag list' do
    @item.tag_list.should == 'pizza, sals'
  end
  
  it 'should add a new tag via tag list' do
    running {
      @item.tag_list = 'pizza, sals, cupcake'
      @item.save
      @item.tag_list.should == 'pizza, sals, cupcake'
    }.should change(Tag, :count).by(1)
  end
end

#####################################################################
#                               S C O P E                           #
#####################################################################
describe Item, 'scope' do
  it 'should have a during scope' do
    Item.during(Date.today).should == Item.all
  end
end

#####################################################################
#                    O B J E C T    M E T H O D S                   #
#####################################################################
describe Item do
  
  before(:each) do
    @item = items(:sals)
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
end

#####################################################################
#                         P R O T E C T I O N                       #
#####################################################################
describe Item, 'protections' do
  
  before(:each) do
    @item = items(:sals)
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
  
  it 'should have a value' do
    Item.new.should have(1).error_on(:value)
  end
  
  it 'should have a description no longer than 255' do
    Item.new(:description=>(1..122).to_a.to_s).should have(1).error_on(:description)
  end
end

#####################################################################
#                       D E S T R U C T I O N                       #
#####################################################################
describe Item, 'destruction' do
  
  it 'should nullify paycheck on destroy' do
    items(:starbucks).destroy
    paychecks(:last_week).item.should be_nil
  end
end