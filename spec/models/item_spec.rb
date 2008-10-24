require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Item, 'relationships' do
  define_models
  
  it 'should belong to a user' do
    items(:default).user.should == users(:default)
  end

  it 'should belong to a paycheck' do
    items(:default).paycheck.should == paychecks(:default)
  end

  it 'should belong to a vendor' do
    items(:default).vendor.should == vendors(:default)
  end
end

#####################################################################
#                             T A G G I N G                         #
#####################################################################
describe Item, 'tagging' do
  define_models
  
  before do
    @item = items(:default)
  end

  it 'should have many taggings' do
    @item.should have(1).taggings
  end

  it 'should have many tags alphabetically' do
    @item.tags.should == [tags(:default)]
  end

  it 'should have a tag list' do
    @item.tag_list.should == 'default'
  end

  it 'should add a new tag via tag list' do
    running {
      running {
        @item.tag_list = 'default, breakfast'
        @item.save
        @item.reload.tag_list.should == 'breakfast, default'
      }.should change(Tag, :count).by(1) 
    }.should change(Tagging, :count).by(1)
  end

  it 'should empty tag list when nothing is passed' do
    running {
      @item.tag_list = ''
      @item.save
      @item.should have(0).tags
    }.should change(Tagging, :count).by(-1)
  end
end

#####################################################################
#                            S C O P E                              #
#####################################################################
describe Item, 'scope' do
  define_models
  it 'should have a during scope' do
    Item.should have(1).on(current_time.to_date)
  end
end

#####################################################################
#                         P R O T E C T I O N                       #
#####################################################################
describe Item, 'protections' do
  define_models
  
  before do
    @item = items(:default)
  end

  it 'should not update user_id through mass assignment' do
    @item.update_attributes :user_id=>users(:other).id
    @item.user_id.should_not == users(:other).id
  end

  it 'should not update user through mass assignment' do
    @item.update_attributes :user=>users(:other)
    @item.user.should_not == users(:other)
  end
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Item, 'validations' do
  define_models
  
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
  define_models
  
  it 'should nullify paycheck on destroy' do
    items(:default).destroy
    paychecks(:default).item.should be_nil
  end
end