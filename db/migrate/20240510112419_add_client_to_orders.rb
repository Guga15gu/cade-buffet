class AddClientToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :client, null: false, foreign_key: true
  end
end
