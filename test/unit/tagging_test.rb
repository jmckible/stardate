require File.dirname(__FILE__) + '/../test_helper'

class TaggingTest < Test::Unit::TestCase
  fixtures :taggings, :tags, :items
  
  def test_item
    assert_equal items(:sals), taggings(:sals_pizza).item
  end
  
  def test_tag
    assert_equal tags(:pizza), taggings(:sals_pizza).tag
  end
  
  def test_presence
    tagging = Tagging.new
    assert !tagging.valid?
    assert_equal @@error[:blank], tagging.errors.on(:tag)
    assert_equal @@error[:blank], tagging.errors.on(:item)
  end
  
  def test_uniqueness
    tagging = taggings(:sals_pizza).clone
    assert !tagging.valid?
    assert_equal @@error[:taken], tagging.errors.on(:tag_id)
  end
  
end
