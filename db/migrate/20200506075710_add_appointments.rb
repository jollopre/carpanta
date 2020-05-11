class AddAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table(:appointments, id: false) do |t|
      t.primary_key :id, :string, limit: 36
      t.string :customer_id, limit: 36
      t.string :offer_id, limit: 36
      t.datetime :starting_at
      t.integer :duration
      t.index :starting_at
      t.timestamps
    end
  end
end
