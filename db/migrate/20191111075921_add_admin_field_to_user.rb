class AddAdminFieldToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
    change_column :users, :email, :string, default: '', null: false
    change_column :users, :phone, :string, default: '', null: false
    change_column :users, :role, :integer, limit: 2
    change_column :users, :gender, :integer, limit: 1
  end
end
