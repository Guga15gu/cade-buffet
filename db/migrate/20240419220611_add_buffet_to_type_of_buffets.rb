class AddBuffetToTypeOfBuffets < ActiveRecord::Migration[7.1]
  def change
    add_reference :type_of_buffets, :buffet, null: false, foreign_key: true
  end
end
