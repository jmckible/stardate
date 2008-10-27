require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  define_models
  before { @tag = tags(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should have many taggings' do
    @tag.should have(1).taggings
  end

  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  it 'should strip spaces before save' do
    tag = Tag.new :name=>' spaces '
    tag.save
    tag.name.should == 'spaces'
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should have a name' do
    Tag.new.should have(1).error_on(:name)
  end

  it 'should have a unique name' do
    tag = @tag.clone
    tag.should have(1).error_on(:name)
  end
end

