class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :email, :string, :null=>false
      t.column :password_salt, :string, :null=>false
      t.column :password_hash, :string, :null=>false
      t.column :timezone, :string, :null=>false
    end
    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
