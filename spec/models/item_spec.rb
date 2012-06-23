require 'spec_helper'

describe Item do
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
  
  it 'should belong to a recurring' do
    items(:other).recurring.should == recurrings(:last)
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
    running { @item.vendor_name = 'New Vendor' }.should change(Vendor, :count).by(1)
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
  #                            S C O P E                              #
  #####################################################################
  it 'should have a during scope' do
    Item.on(Date.new(2008, 1, 1)).size.should == 3
  end
  
  it 'should find by vendor' do
    Item.from_vendor(vendors(:default)).size.should == 2
    Item.from_vendor(nil).size.should == Item.count
  end
  
  # it 'should find by tag' do
  #   Item.find_tagged_with('default').size.should == 2
  #   Item.find_tagged_with(tags(:default)).size.should == 2
  #   Item.from_vendor(vendors(:default)).find_tagged_with(tags(:default)).size.should == 1
  # end
  
  #####################################################################
  #                        L I F E    C Y C L E                       #
  #####################################################################
  it 'should assign amortization values if none provided' do
    item = Item.new :date=>Date.today, :explicit_value=>10
    item.save
    item.start.should == Date.today
    item.finish.should == Date.today
    item.per_diem.should == -10
  end
  
  it 'should not overwrite provided amortization period' do
    item = Item.new :date=>Date.today, :start=>(Date.today - 9), :finish=>Date.today, :explicit_value=>'+10'
    item.save
    item.start.should == Date.today - 9
    item.finish.should == Date.today
    item.per_diem.should == 1
  end
  
  it 'should correct reversed start/finish' do
    item = Item.new :date=>Date.today, :finish=>(Date.today - 9), :start=>Date.today, :explicit_value=>'+10'
    item.save
    item.start.should == Date.today - 9
    item.finish.should == Date.today
    item.per_diem.should == 1
  end
  
  it 'should update per diem if existing amortization period changed' do
    item = items(:default)
    item.finish = item.date + 9
    item.save
    item.finish.should == item.date + 9
    item.per_diem.to_f.should == -1
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