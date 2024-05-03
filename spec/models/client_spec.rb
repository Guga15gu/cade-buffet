require 'rails_helper'

RSpec.describe Client, type: :model do
  describe '#valid?' do
    it 'e cpf é inválido' do
      client = Client.create(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  1234567345)

      result = client.valid?

      expect(result).to eq false
    end

    it 'e cpf é válido' do
      client = Client.create(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')

      result = client.valid?

      expect(result).to eq true
    end

    it 'tem que ter um cpf único' do
      Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  64433482064)

      client = Client.create(email: 'joao@email.com', password: 'password', name: 'Joao', cpf:  64433482064)

      result = client.valid?

      expect(result).to eq false
    end
  end
end
