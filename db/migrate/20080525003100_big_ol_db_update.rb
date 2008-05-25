class BigOlDbUpdate < ActiveRecord::Migration
  def self.up
    
    change_table :items do |t|
      t.change :user_id, :integer, :null=>false
      t.change :date, :date, :null=>false
    end
    
    change_table :jobs do |t|
      t.change :user_id, :integer, :null=>false
      t.change :name, :string, :null=>false
    end
    
    change_table :paychecks do |t|
      t.change :job_id, :integer, :null=>false
      t.change :item_id, :integer, :null=>false
    end
    
    change_table :recurrings do |t|
      t.change :user_id, :integer, :null=>false
      t.remove :category_id
      t.change :day, :integer, :null=>false, :default=>1
      t.change :value, :integer, :null=>false, :default=>0
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, :item_id
    
    add_index :tags, :name
    
    change_table :tasks do |t|
      t.change :job_id, :integer, :null=>false
      t.change :date, :date, :null=>false
      t.change :minutes, :integer, :null=>false, :default=>0
      t.change :paycheck_id, :integer, :null=>false
    end
    
    add_index :tasks, :date
    
  end

  def self.down
  end
end
