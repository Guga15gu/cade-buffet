class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :buffet, null: false, foreign_key: true
      t.references :buffet_type, null: false, foreign_key: true
      t.date :date
      t.integer :number_of_guests
      t.string :address
      t.string :event_details
      t.string :code
      t.integer "status", default: 0

      t.timestamps
    end
  end
end
