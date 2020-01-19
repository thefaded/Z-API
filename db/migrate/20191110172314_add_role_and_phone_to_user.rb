class AddRoleAndPhoneToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :phone, :string
  end
end
