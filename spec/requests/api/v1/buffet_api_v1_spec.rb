require 'rails_helper'

describe 'GET /api/v1/buffets/1' do
  context 'GET /api/v1/buffets/1' do
    it 'e sucesso' do
      # Arrange
      buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

      buffet = Buffet.create!(
        business_name: 'Buffet Delícias',
        corporate_name: 'Empresa de Buffet Ltda',
        registration_number: '12345678901234',
        contact_phone: '(11) 1234-5678',
        address: 'Rua dos Sabores, 123',
        district: 'Centro',
        state: 'SP',
        city: 'São Paulo',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos corporativos',
        payment_methods: 'Cartão de crédito, Dinheiro',
        buffet_owner_user: buffet_owner_user
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response["business_name"]).to eq 'Buffet Delícias'
      expect(json_response["contact_phone"]).to eq '(11) 1234-5678'
      expect(json_response["address"]).to eq 'Rua dos Sabores, 123'
      expect(json_response["district"]).to eq 'Centro'
      expect(json_response["state"]).to eq 'SP'
      expect(json_response["city"]).to eq 'São Paulo'
      expect(json_response["postal_code"]).to eq '12345-678'
      expect(json_response["description"]).to eq 'Buffet especializado em eventos corporativos'
      expect(json_response["payment_methods"]).to eq 'Cartão de crédito, Dinheiro'
      expect(json_response.keys.length).to eq 9

      expect(json_response.keys).not_to include "corporate_name"
      expect(json_response.keys).not_to include "registration_number"
      expect(json_response.keys).not_to include "created_at"
      expect(json_response.keys).not_to include "updated_at"
    end

    it 'e falha se buffet não é encontrado' do
      # Arrange
      buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

      Buffet.create!(
        business_name: 'Buffet Delícias',
        corporate_name: 'Empresa de Buffet Ltda',
        registration_number: '12345678901234',
        contact_phone: '(11) 1234-5678',
        address: 'Rua dos Sabores, 123',
        district: 'Centro',
        state: 'SP',
        city: 'São Paulo',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos corporativos',
        payment_methods: 'Cartão de crédito, Dinheiro',
        buffet_owner_user: buffet_owner_user
      )
      # Act
      get "/api/v1/buffets/9999"

      # Assert
      expect(response.status).to eq 404
    end
  end

end
