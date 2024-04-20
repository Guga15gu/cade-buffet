class RenameTypesOfBuffets < ActiveRecord::Migration[7.1]
  rename_table :types_of_buffets, :buffet_types
end
