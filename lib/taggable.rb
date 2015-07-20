module Taggable
  extend ActiveSupport::Concern

  included do
    scope :tagged_with, ->(tag){ includes(:taggings).where(taggings: { tag_id: tag.id}).references(:taggings) }
  end

  def self.included(base)
    base.has_many :taggings, as: :taggable
    base.has_many :tags, ->{ order('tags.name') }, through: :taggings
  end

  def tag_list
    tags.reload.collect(&:name).join(', ')
  end

  def tag_list=(tag_string)
    new_tags = []
    tag_string.split(',').compact.each do |name|
      new_tags << Tag.where(name: name.strip).first_or_create
    end
    taggings.each { |t| t.destroy unless new_tags.include?(t.tag) }
    new_tags.each { |t| tags << t unless tags.include?(t) }
  end

end
