class ChangeIdCustomers < ActiveRecord::Migration[5.0]
  def up
    change_column(:customers, :id, :string, limit: 36)
  end

  def down
    change_column(:customers, :id, :integer)
  end
end
