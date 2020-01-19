class AddMissingFieldsToTerminal < ActiveRecord::Migration[5.2]
  def change
    add_column :terminals, :name, :string, default: '', null: false, limit: 255
  end
end
