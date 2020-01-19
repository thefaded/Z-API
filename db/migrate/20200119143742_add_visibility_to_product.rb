class AddVisibilityToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :hidden, :boolean, default: false, null: false
  end
end
