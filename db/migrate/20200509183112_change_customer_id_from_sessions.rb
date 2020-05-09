class ChangeCustomerIdFromSessions < ActiveRecord::Migration[5.0]
  def up
    change_column(:sessions, :customer_id, :string, limit: 36)
  end

  def down
    change_column(:sessions, :customer_id, :integer)
  end
end
