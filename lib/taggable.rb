module Taggable

  def self.included(base)
    base.has_many :taggings, as: :taggable
    base.has_many :tags, ->{ order('tags.name') }, through: :taggings
  end

  def tag_list
    tags.reload.map(&:name).join(', ')
  end

  def tag_list=(tag_string)
    new_tags = []
    tag_string.split(',').compact.each do |name|
      new_tags << Tag.find_or_create_by_name(name.strip)
    end
    taggings.each { |t| t.destroy unless new_tags.include?(t.tag) }
    new_tags.each { |t| tags << t unless tags.include?(t) }
  end

end
