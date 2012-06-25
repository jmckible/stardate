class Household < ActiveRecord::Base
  include Totalling
  
  has_many :budgets
  has_many :users
  has_many :items
  
  has_many :taggings, :through=>:items
  has_many :tags, :through=>:taggings, :uniq=>true, order: 'tags.name' do
    def since(date)
      where("items.created_at >= ?", date)
    end
  end
  
  has_many :vendors, :through=>:items, :uniq=>true
  
  validates_presence_of :name
end
