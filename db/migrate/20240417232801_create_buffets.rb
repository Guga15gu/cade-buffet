class CreateBuffets < ActiveRecord::Migration[7.1]
  def change
    create_table :buffets do |t|
      t.string :business_name
      t.string :corporate_name
      t.string :registration_number
      t.string :contact_phone
      t.string :address
      t.string :district
      t.string :state
      t.string :city
      t.string :postal_code
      t.string :description
      t.string :payment_methods
      t.references :buffet_owner_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
