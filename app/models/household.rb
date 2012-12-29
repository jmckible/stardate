class Household < ActiveRecord::Base
  include Totalling

  has_many :accounts, order: 'accounts.name'
  has_many :budgets
  has_many :users
  has_many :transactions
  
  has_many :taggings, :through=>:transactions
  has_many :tags, :through=>:taggings, :uniq=>true, order: 'tags.name' do
    def visible_by(user)
      where("transactions.created_at >= ? AND (transactions.secret = ? OR transactions.user_id = ?)", user.created_at, false, user.id)
    end
  end
  
  has_many :vendors, :through=>:transactions, :uniq=>true, order: 'vendors.name' do
    def visible_by(user)
      where("transactions.created_at >= ? AND (transactions.secret = ? OR transactions.user_id = ?)", user.created_at, false, user.id)
    end
  end

  def cash
    accounts.cash.first
  end
  
  def slush
    accounts.slush.first
  end

  def general_income
    accounts.general_income.first
  end

  # For scheduled deferral funding
  def default_user
    users.first
  end

  validates_presence_of :name
end
