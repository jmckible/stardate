class Recurring < ApplicationRecord
  include Taggable

  belongs_to :credit, class_name: 'Account', optional: true
  belongs_to :debit,  class_name: 'Account', optional: true
  belongs_to :user
  belongs_to :vendor, optional: true

  has_many :transactions, dependent: :nullify

  scope :on, ->(date){
    if date.is_a?(Date)
      if date == date.end_of_month
        where("day >= ?", date.mday)
      else
        where(day: date.mday)
      end
    else
      where(day: date)
    end
  }

  def to_transaction
    Transaction.new date: Time.zone.today,
                  amount: amount,
                  vendor: vendor,
                tag_list: tag_list,
                   debit: debit,
                  credit: credit,
               recurring: self,
                    user: user,
               household: user.household
  end

  def vendor_name
    vendor&.name
  end

  def vendor_name=(string)
    if string.blank?
      self.vendor = nil
    else
      self.vendor = Vendor.where(name: string).first_or_create
    end
  end

  validates_presence_of     :user_id
  validates_numericality_of :amount, only_integer: true
  validates_numericality_of :day, in: 1..31

end
