class AddConfirmedNeededCollumnsToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :tax_or_discount, :integer
    add_column :orders, :description_tax_or_discount, :string
    add_column :orders, :payment_method, :string
    add_column :orders, :payment_date, :date
  end
end
