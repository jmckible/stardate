class Budget < ActiveRecord::Base
  include Taggable

  belongs_to :household

  def expected_during(period)
    (amount / 30.0 * period.count).round
  end

  def difference_during(period)
    expected_during(period) + household.transactions.tagged_with(tags).during(period).sum(&:value)
  end

  validates :household_id, presence: true
  validates :name,         presence: true
end
