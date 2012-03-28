class AddUserName < ActiveRecord::Migration
  def up
    add_column :users, :name, :string
    add_column :items, :secret, :boolean, :default=>false
  end

  def down
    remove_column :users, :name
    remove_column :items, :secret
  end
end
