class DropTasks < ActiveRecord::Migration[5.0]
  def change
    drop_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.timestamps
    end
  end
end
