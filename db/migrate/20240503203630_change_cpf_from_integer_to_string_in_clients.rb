class ChangeCpfFromIntegerToStringInClients < ActiveRecord::Migration[7.1]
  def change
    change_column :clients, :cpf, :string
  end
end
