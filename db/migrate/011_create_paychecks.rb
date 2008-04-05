class CreatePaychecks < ActiveRecord::Migration
  def self.up
    create_table :paychecks do |t|
      t.column :job_id,      :integer  
      t.column :item_id,     :integer
      t.column :created_at,  :datetime
      t.column :description, :string
      t.column :value,       :decimal, :scale=>2, :precision=>8
      t.column :paid,        :boolean
    end
    add_index :paychecks, :job_id
    add_index :paychecks, :item_id
    
    add_column :tasks, :paycheck_id, :integer
    add_index  :tasks, :paycheck_id
  end

  def self.down    
    remove_index  :tasks, :paycheck_id
    remove_column :tasks, :paycheck_id
    
    drop_table :paychecks
  end
end
