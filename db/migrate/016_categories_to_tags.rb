class CategoriesToTags < ActiveRecord::Migration
  def self.up
    for item in Item.find(:all, :conditions=>"category_id is not null")
      tag = Tag.find_or_create_by_name item.category.name.downcase
      item.tags << tag
      item.save!
    end
  end

  def self.down
    Tagging.find(:all).each(&:destroy)
    Tag.find(:all).each(&:destroy)
  end
end
