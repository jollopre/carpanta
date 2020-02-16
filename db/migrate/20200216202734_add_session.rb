class AddSession < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.integer :price
      t.references :customer, type: :integer
      t.references :task, type: :integer
      t.timestamps
    end
  end
end
