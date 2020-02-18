class AddSession < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.integer :price
      t.references :customer, type: :integer, foreign_key: true, null: false
      t.references :task, type: :integer, foreign_key: true, null: false
      t.timestamps
    end
  end
end
