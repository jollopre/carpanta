class AddAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.integer :customer_id, null: false
      t.integer :offer_id, null: false
      t.datetime :starting_at
      t.integer :duration
      t.index :customer_id
      t.timestamps
    end
  end
end
