class CreateTerminals < ActiveRecord::Migration[5.2]
  def change
    create_table :terminals do |t|

      t.timestamps
    end
  end
end
