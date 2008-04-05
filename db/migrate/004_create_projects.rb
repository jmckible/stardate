class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column :user_id, :integer
      t.column :name, :string
      t.column :active, :boolean, :default=>true
      t.column :created_at, :datetime
      t.column :rate, :integer
    end
  end

  def self.down
    drop_table :projects
  end
end
