require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Tagging, 'relationships' do
  it 'should belong to a tag' do
    taggings(:pizza_food).tag.should == tags(:food)
  end
  
  it 'should belong to and item' do
    taggings(:pizza_food).taggable.should == items(:pizza)
  end
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Tagging, 'validations' do
  it' should belong to a tag' do
    Tagging.new.should have(1).error_on(:tag_id)
  end
  
  it 'should tag an item uniquely' do
    tagging = taggings(:pizza_food).clone
    tagging.should have(1).error_on(:tag_id)
  end
end