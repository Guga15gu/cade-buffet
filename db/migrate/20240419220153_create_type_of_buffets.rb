class CreateTypeOfBuffets < ActiveRecord::Migration[7.1]
  def change
    create_table :type_of_buffets do |t|
      t.string :name
      t.string :description
      t.integer :max_capacity_people
      t.integer :min_capacity_people
      t.integer :duration
      t.string :menu
      t.boolean :alcoholic_beverages
      t.boolean :decoration
      t.boolean :parking_valet
      t.boolean :exclusive_address

      t.timestamps
    end
  end
end
