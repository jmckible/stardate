require File.dirname(__FILE__) + '/../spec_helper'

describe Item do
  define_models
  before { @item = items(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @item.user.should == users(:default)
  end

  it 'should belong to a paycheck' do
    @item.paycheck.should == paychecks(:default)
  end

  it 'should belong to a vendor' do
    @item.vendor.should == vendors(:default)
  end

  #####################################################################
  #                             T A G G I N G                         #
  #####################################################################
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

  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should have a during scope' do
    Item.should have(1).on(current_time.to_date)
  end

  #####################################################################
  #                         P R O T E C T I O N                       #
  #####################################################################
  it 'should not update user_id through mass assignment' do
    @item.update_attributes :user_id=>users(:other).id
    @item.user_id.should_not == users(:other).id
  end

  it 'should not update user through mass assignment' do
    @item.update_attributes :user=>users(:other)
    @item.user(true).should_not == users(:other)
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should have a date' do
    Item.new.should have(1).error_on(:date)
  end

  it 'should have a user_id' do
    Item.new.should have(1).error_on(:user_id)
  end

  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should nullify paycheck on destroy' do
    @item.destroy
    @item.paycheck(true).should be_nil
  end

end