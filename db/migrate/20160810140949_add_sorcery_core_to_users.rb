class AddSorceryCoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :salt, :string
    rename_column :users, :password, :crypted_password
    change_column :users, :email, :string, null: false
  end
end
