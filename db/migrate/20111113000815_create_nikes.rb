class CreateNikes < ActiveRecord::Migration
  def change
    create_table :nikes do |t|
      t.date     :date
      t.integer  :user_id
      t.integer  :minutes, default: 0
      t.string   :description
      t.timestamps
    end
    add_index :nikes, :user_id
  end
end
