class Household < ActiveRecord::Base
  include Totalling

  belongs_to :cash, class_name: 'Account'
  belongs_to :general_income, class_name: 'Account'
  belongs_to :slush, class_name: 'Account'

  has_many :accounts
  has_many :budgets
  has_many :users
  has_many :transactions
  
  has_many :taggings, :through=>:transactions
  has_many :tags, :through=>:taggings do
    def visible_by(user)
      where("transactions.created_at >= ? AND (transactions.secret = ? OR transactions.user_id = ?)", user.created_at, false, user.id)
    end
  end
  
  has_many :vendors, :through=>:transactions do
    def visible_by(user)
      where("transactions.created_at >= ? AND (transactions.secret = ? OR transactions.user_id = ?)", user.created_at, false, user.id)
    end
  end

  # For scheduled deferral funding
  def default_user
    users.first
  end

  def cash_income(period)
    cash.debits.on(period).sum(:amount)
  end

  validates_presence_of :name
end
