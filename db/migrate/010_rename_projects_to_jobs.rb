class RenameProjectsToJobs < ActiveRecord::Migration
  def self.up
    rename_table :projects, :jobs
    change_column :jobs, :rate, :decimal, :scale=>2, :precision=>6
    rename_column :tasks, :project_id, :job_id
  end

  def self.down
    rename_column :tasks, :job_id, :project_id
    change_column :projects, :rate, :integer
    rename_table :jobs, :projects
  end
end
