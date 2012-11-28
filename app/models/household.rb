class Household < ActiveRecord::Base
  include Totalling

  has_many :accounts, order: 'accounts.name'
  has_many :budgets
  has_many :users
  has_many :transactions
  
  has_many :taggings, :through=>:items
  has_many :tags, :through=>:taggings, :uniq=>true, order: 'tags.name' do
    def visible_by(user)
      where("items.created_at >= ? AND (items.secret = ? OR items.user_id = ?)", user.created_at, false, user.id)
    end
  end
  
  has_many :vendors, :through=>:items, :uniq=>true, order: 'vendors.name' do
    def visible_by(user)
      where("items.created_at >= ? AND (items.secret = ? OR items.user_id = ?)", user.created_at, false, user.id)
    end
  end

  def cash
    accounts.cash.first
  end
  
  def slush
    accounts.slush.first
  end

  def spin_up(name, tag_string)
    tag_list = tag_string.split(',').collect{|t|Tag.find_by_name t.strip}.compact
    expense = accounts.build name: name, expense: true
    expense.save
    expense.tags = tag_list
    expense.save

    expense.pull_in tag_list
  end

  validates_presence_of :name
end
