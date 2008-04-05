require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase
  fixtures :tags, :taggings, :items

  def test_taggings
    assert_equal [taggings(:sals_pizza)], tags(:pizza).taggings
  end
  
  def test_items
    assert_equal [items(:sals)], tags(:pizza).items
  end
  
  def test_strip_name
    tag = Tag.new :name=>' spaces '
    assert tag.valid?
    assert tag.save
    assert_equal 'spaces', tag.name
  end

  def test_unique_name
    tag = tags(:pizza).clone
    assert !tag.valid?
    assert_equal @@error[:taken], tag.errors.on(:name)
  end
  
  def test_presence_of_name
    tag = Tag.new
    assert !tag.valid?
    assert_equal @@error[:blank], tag.errors.on(:name)
  end
  
  def test_deletion
    tags(:pizza).destroy
    assert_raise(ActiveRecord::RecordNotFound){taggings(:sals_pizza)}
  end
  
end
