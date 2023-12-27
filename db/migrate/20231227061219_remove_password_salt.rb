class RemovePasswordSalt < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :password_salt, :string
    rename_column :users, :password_hash, :password_digest
    remove_index  :users, :email
    add_index     :users, :email, unique: true
  end
end
