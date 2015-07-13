class Job < ActiveRecord::Base

  belongs_to :user
  belongs_to :vendor

  has_many   :paychecks, -> { order('created_at') }, dependent: :destroy
  has_many   :tasks,     -> { order('date')       }, dependent: :destroy

  scope :active, where(active: true)

  attr_accessible :active, :name, :rate

  validates_presence_of     :name, :user_id
  validates_numericality_of :rate

end
