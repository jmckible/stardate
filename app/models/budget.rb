class Budget < ActiveRecord::Base
  include Taggable

  belongs_to :household

  scope :tagged_with, ->(tag_or_tags){ 
    if tag_or_tags.is_a?(Array)
      includes(:taggings).where('taggings.tag_id IN (?)', tag_or_tags.collect(&:id))
    else
      includes(:taggings).where('taggings.tag_id = ?', tag_or_tags.id)
    end
  }

  default_scope order('budgets.amount DESC')

  def expected_during(period)
    (amount / 30.0 * period.count).round
  end

  def difference_during(period)
    expected_during(period) + household.items.tagged_with(tags).during(period).sum(&:value)
  end

  validates_presence_of :household_id

end
