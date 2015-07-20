class Paycheck < ActiveRecord::Base

  # belongs_to :transaction
  belongs_to :job

  has_many :tasks, dependent: :nullify

  scope :unpaid, ->{ where(transaction_id: nil) }

  attr_accessor :paid
  def paid?
    transaction_id || paid == true || paid == 1
  end

  # before_save :create_transaction
  # def create_transaction
  #   if paid && !transaction
  #     job.user.transactions.create paycheck: self, explicit_value: "+#{value}", description: description, date: Date.today
  #   end
  # end

  validates_presence_of     :job_id
  validates_numericality_of :value

end
