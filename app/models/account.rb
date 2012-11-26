class Account < ActiveRecord::Base
  include Taggable

  belongs_to :deferral, class_name: 'Account'
  belongs_to :household

  has_many :credits, class_name: 'Transaction', foreign_key: 'credit_id'
  has_many :debits,  class_name: 'Transaction', foreign_key: 'debit_id'

  def transactions
    household.transactions.where('debit_id = ? OR credit_id = ?', id, id)
  end

  scope :asset,     where(asset: true)
  scope :deferred,  where(deferred: true)
  scope :equity,    where(equity: true)
  scope :expense,   where(expense: true)
  scope :income,    where(income: true)
  scope :liability, where(liability: true)

  def pull_in(tag_list)
    tag_list = tag_list.split(',').collect{|t|Tag.find_by_name t.strip}.compact if tag_list.is_a?(String)

    tag_list.each{|t|tags << t unless tags.include?(t)}

    household.transactions.tagged_with(tag_list).each do |transaction|
      if transaction.amount < 0
        transaction.update_attribute(:debit, self) if transaction.debit.nil?
      else
        transaction.update_attribute(:credit, self)  if transaction.credit.nil?
      end
    end
  end
  
end
