class AddOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string :tasks
      t.integer :price
      t.timestamps
    end
  end
end
