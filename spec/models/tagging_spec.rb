require File.dirname(__FILE__) + '/../spec_helper'

describe Tagging do
  define_models
  before { @tagging = taggings(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a tag' do
    @tagging.tag.should == tags(:default)
  end

  it 'should belong to and item' do
    @tagging.taggable.should == items(:default)
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a tag' do
    Tagging.new.should have(1).error_on(:tag_id)
  end

  it 'should tag an item uniquely' do
    tagging = @tagging.clone
    tagging.should have(1).error_on(:tag_id)
  end
end

