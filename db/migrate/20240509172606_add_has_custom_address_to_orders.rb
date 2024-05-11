class AddHasCustomAddressToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :has_custom_address, :boolean
  end
end
