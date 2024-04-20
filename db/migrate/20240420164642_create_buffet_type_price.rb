class CreateBuffetTypePrice < ActiveRecord::Migration[7.1]
  def change
    create_table :buffet_type_prices do |t|
      t.integer :base_price_weekday
      t.integer :additional_per_person_weekday
      t.integer :additional_per_hour_weekday

      t.integer :base_price_weekend
      t.integer :additional_per_person_weekend
      t.integer :additional_per_hour_weekend

      t.references :buffet_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
