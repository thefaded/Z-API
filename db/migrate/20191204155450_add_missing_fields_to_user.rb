class AddMissingFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string, default: '', null: false, limit: 255
    add_column :users, :last_name, :string, default: '', null: false, limit: 255
    add_column :users, :created_by_id, :integer
  end
end
