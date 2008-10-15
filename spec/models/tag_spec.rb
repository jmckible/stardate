require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Tag, 'relationships' do
  it 'should have many taggings' do
    tags(:food).should have(3).taggings
  end
end

#####################################################################
#                    O B J E C T    M E T H O D S                   #
#####################################################################
describe Tag do
  it 'should strip spaces before save' do
    tag = Tag.new :name=>' spaces '
    tag.save
    tag.name.should == 'spaces'
  end
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Tag, 'validations' do
  it 'should have a name' do
    Tag.new.should have(1).error_on(:name)
  end
  
  it 'should have a unique name' do
    tag = tags(:food).clone
    tag.should have(1).error_on(:name)
  end
end