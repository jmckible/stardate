class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :project_id, :integer
      t.column :created_at, :datetime
      t.column :date, :date
      t.column :minutes, :integer
    end
  end

  def self.down
    drop_table :tasks
  end
end
