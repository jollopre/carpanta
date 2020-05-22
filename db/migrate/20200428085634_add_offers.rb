class AddOffers < ActiveRecord::Migration[5.0]
  def change
    create_table(:offers, id: false) do |t|
      t.primary_key :id, :string, limit: 36
      t.string :tasks
      t.integer :price
      t.timestamps
    end
  end
end
