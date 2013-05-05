require 'spec_helper'

describe Transaction do
  before { @transaction = transactions(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a user' do
    @transaction.user.should == users(:default)
  end

  it 'should belong to a paycheck' do
    @transaction.paycheck.should == paychecks(:default)
  end
  
  it 'should belong to a recurring' do
    transactions(:other).recurring.should == recurrings(:last)
  end

  it 'should belong to a vendor' do
    @transaction.vendor.should == vendors(:default)
  end
  
  it 'should access vendor name' do
    @transaction.vendor_name.should == vendors(:default).name
    Item.new.vendor_name.should be_nil
  end
  
  it 'should set vendor name with existing vendor' do
    running {
      @transaction.vendor_name = vendors(:other).name
      @transaction.save
      @transaction.reload.vendor.should == vendors(:other)
    }.should_not change(Vendor, :count)
  end
  
  it 'should set vendor name with new vendor' do
    running { @transaction.vendor_name = 'New Vendor' }.should change(Vendor, :count).by(1)
  end
  
  it 'should clear vendor when name set to nil' do
    @transaction.vendor_name = nil
    @transaction.vendor.should be_nil
  end
  
  it 'should clear vendor when name set empty string' do
    @transaction.vendor_name = ' '
    @transaction.vendor.should be_nil
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
  
  it 'should find single tagged' do
    Item.tagged_with(tags(:default)).count.should == 2
  end

  it 'should find multipe tags' do
    Item.tagged_with(tags(:default, :other)).count.should == 3
  end
  
  #####################################################################
  #                        L I F E    C Y C L E                       #
  #####################################################################
  it 'should assign amortization values if none provided' do
    transaction = Item.new :date=>Date.today, :explicit_value=>10
    transaction.save
    transaction.start.should == Date.today
    transaction.finish.should == Date.today
    transaction.per_diem.should == -10
  end
  
  it 'should not overwrite provided amortization period' do
    transaction = Item.new :date=>Date.today, :start=>(Date.today - 9), :finish=>Date.today, :explicit_value=>'+10'
    transaction.save
    transaction.start.should == Date.today - 9
    transaction.finish.should == Date.today
    transaction.per_diem.should == 1
  end
  
  it 'should correct reversed start/finish' do
    transaction = Item.new :date=>Date.today, :finish=>(Date.today - 9), :start=>Date.today, :explicit_value=>'+10'
    transaction.save
    transaction.start.should == Date.today - 9
    transaction.finish.should == Date.today
    transaction.per_diem.should == 1
  end
  
  it 'should update per diem if existing amortization period changed' do
    transaction = transactions(:default)
    transaction.finish = transaction.date + 9
    transaction.save
    transaction.finish.should == transaction.date + 9
    transaction.per_diem.to_f.should == -1
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
    @transaction.destroy
    @transaction.paycheck(true).should be_nil
  end

end