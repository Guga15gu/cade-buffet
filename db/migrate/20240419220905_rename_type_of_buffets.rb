class RenameTypeOfBuffets < ActiveRecord::Migration[7.1]
  def change
    rename_table :type_of_buffets, :types_of_buffets
  end
end
