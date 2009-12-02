require 'spec_helper'

describe Image do
  before { @image = images(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to an item' do
    @image.item.should == items(:default)
  end
  
end
