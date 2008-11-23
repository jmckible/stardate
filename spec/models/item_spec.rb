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
  
  it 'should access vendor name' do
    @item.vendor_name.should == vendors(:default).name
    Item.new.vendor_name.should be_nil
  end
  
  it 'should set vendor name with existing vendor' do
    running {
      @item.vendor_name = vendors(:other).name
      @item.save
      @item.reload.vendor.should == vendors(:other)
    }.should_not change(Vendor, :count)
  end
  
  it 'should set vendor name with new vendor' do
    @item.vendor_name = 'New Vendor'
    @item.vendor.should be_new_record
    running {
      @item.save
    }.should change(Vendor, :count).by(1)
  end
  
  it 'should clear vendor when name set to nil' do
    @item.vendor_name = nil
    @item.vendor.should be_nil
  end
  
  it 'should clear vendor when name set empty string' do
    @item.vendor_name = ' '
    @item.vendor.should be_nil
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
    @item.tag_list.should == ['default']
  end

  it 'should add a new tag via tag list' do
    running {
      running {
        @item.tag_list = 'default, breakfast'
        @item.save
        @item.reload.tag_list.should == ['default', 'breakfast']
      }.should change(Tag, :count).by(1) 
    }.should change(Tagging, :count).by(1)
  end
  
  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should have a during scope' do
    Item.should have(2).on(current_time.to_date)
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