require 'rails_helper'

describe 'buffet_type API' do
  context 'GET /api/v1/buffets/:buffets_id/buffet_types' do
    it 'e lista todos os tipos de buffet em ordem alfabética por nome' do
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
      buffet_type_casamento = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      buffet_type_festa = BuffetType.create!(
        name: 'Festa',
        description: 'Festa com comida',
        max_capacity_people: 11,
        min_capacity_people: 6,
        duration: 240,
        menu: 'Comida colorida',
        alcoholic_beverages: false,
        decoration: true,
        parking_valet: false,
        exclusive_address: true,
        buffet: buffet
      )
      buffet_type_alegre = BuffetType.create!(
        name: 'Alegre',
        description: 'Alegria com comida',
        max_capacity_people: 12,
        min_capacity_people: 7,
        duration: 350,
        menu: 'Água e salgados',
        alcoholic_beverages: false,
        decoration: true,
        parking_valet: false,
        exclusive_address: true,
        buffet: buffet
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 3

      expect(json_response[0]["buffet_id"]).to eq buffet.id
      expect(json_response[0]["id"]).to eq buffet_type_alegre.id
      expect(json_response[0]["name"]).to eq 'Alegre'
      expect(json_response[0]["description"]).to eq 'Alegria com comida'
      expect(json_response[0]["max_capacity_people"]).to eq 12
      expect(json_response[0]["min_capacity_people"]).to eq 7
      expect(json_response[0]["duration"]).to eq 350
      expect(json_response[0]["menu"]).to eq 'Água e salgados'
      expect(json_response[0]["alcoholic_beverages"]).to eq false
      expect(json_response[0]["decoration"]).to eq true
      expect(json_response[0]["parking_valet"]).to eq false
      expect(json_response[0]["exclusive_address"]).to eq true
      expect(json_response[0].keys.length).to eq 12
      expect(json_response[0].keys).not_to include "created_at"
      expect(json_response[0].keys).not_to include "updated_at"

      expect(json_response[1]["buffet_id"]).to eq buffet.id
      expect(json_response[1]["id"]).to eq buffet_type_casamento.id
      expect(json_response[1]["name"]).to eq 'Casamento'
      expect(json_response[1]["description"]).to eq 'Casamento com comida'
      expect(json_response[1]["max_capacity_people"]).to eq 10
      expect(json_response[1]["min_capacity_people"]).to eq 5
      expect(json_response[1]["duration"]).to eq 120
      expect(json_response[1]["menu"]).to eq 'Comida caseira e doce'
      expect(json_response[1]["alcoholic_beverages"]).to eq true
      expect(json_response[1]["decoration"]).to eq true
      expect(json_response[1]["parking_valet"]).to eq true
      expect(json_response[1]["exclusive_address"]).to eq true
      expect(json_response[1].keys.length).to eq 12
      expect(json_response[1].keys).not_to include "created_at"
      expect(json_response[1].keys).not_to include "updated_at"

      expect(json_response[2]["buffet_id"]).to eq buffet.id
      expect(json_response[2]["id"]).to eq buffet_type_festa.id
      expect(json_response[2]["name"]).to eq 'Festa'
      expect(json_response[2]["description"]).to eq 'Festa com comida'
      expect(json_response[2]["max_capacity_people"]).to eq 11
      expect(json_response[2]["min_capacity_people"]).to eq 6
      expect(json_response[2]["duration"]).to eq 240
      expect(json_response[2]["menu"]).to eq 'Comida colorida'
      expect(json_response[2]["alcoholic_beverages"]).to eq false
      expect(json_response[2]["decoration"]).to eq true
      expect(json_response[2]["parking_valet"]).to eq false
      expect(json_response[2]["exclusive_address"]).to eq true
      expect(json_response[2].keys.length).to eq 12
      expect(json_response[2].keys).not_to include "created_at"
      expect(json_response[2].keys).not_to include "updated_at"
    end

    it 'e retorna vazio se não existe nenhum tipo de buffet' do
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
      get "/api/v1/buffets/#{buffet.id}/buffet_types"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 0
      expect(json_response).to eq []
    end

    it 'e retorna erro se o id do buffet não existe' do
      # Act
      get "/api/v1/buffets/1/buffet_types"

      # Assert
      expect(response.status).to eq 404
    end

    it 'e não lista tipos de buffet de outro buffet' do
      # Arrange
      another_buffet_owner_user = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
      another_buffet = Buffet.create!(
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
        buffet_owner_user: another_buffet_owner_user
      )
      another_buffet_type_praiano = BuffetType.create!(
        name: 'Praiano',
        description: 'Praiano',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: another_buffet
      )

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
      buffet_type_casamento = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      buffet_type_festa = BuffetType.create!(
        name: 'Festa',
        description: 'Festa com comida',
        max_capacity_people: 11,
        min_capacity_people: 6,
        duration: 240,
        menu: 'Comida colorida',
        alcoholic_beverages: false,
        decoration: true,
        parking_valet: false,
        exclusive_address: true,
        buffet: buffet
      )
      buffet_type_alegre = BuffetType.create!(
        name: 'Alegre',
        description: 'Alegria com comida',
        max_capacity_people: 12,
        min_capacity_people: 7,
        duration: 350,
        menu: 'Água e salgados',
        alcoholic_beverages: false,
        decoration: true,
        parking_valet: false,
        exclusive_address: true,
        buffet: buffet
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 3

      expect(json_response[0]["buffet_id"]).to eq buffet.id
      expect(json_response[0]["id"]).to eq buffet_type_alegre.id
      expect(json_response[0]["name"]).to eq 'Alegre'

      expect(json_response[1]["buffet_id"]).to eq buffet.id
      expect(json_response[1]["id"]).to eq buffet_type_casamento.id
      expect(json_response[1]["name"]).to eq 'Casamento'

      expect(json_response[2]["buffet_id"]).to eq buffet.id
      expect(json_response[2]["id"]).to eq buffet_type_festa.id
      expect(json_response[2]["name"]).to eq 'Festa'
    end
  end

  context 'GET /api/v1/buffets/:buffets_id/buffet_types/1/available?=date=15-05-2024&number_of_guests=6' do
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
      buffet_type = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      buffet_type_price = BuffetTypePrice.create!(
        base_price_weekday: 10,
        additional_per_person_weekday: 10,
        additional_per_hour_weekday: 20,
        base_price_weekend: 20,
        additional_per_person_weekend: 20,
        additional_per_hour_weekend: 40,
        buffet_type: buffet_type
      )

      extra_people = 6 - buffet_type.min_capacity_people
      if Date.tomorrow.on_weekday?
        min_value = buffet_type_price.base_price_weekday
        additional_per_person = buffet_type_price.additional_per_person_weekday
      else
        min_value = buffet_type_price.base_price_weekend
        additional_per_person = buffet_type_price.additional_per_person_weekend
      end

      price = min_value + extra_people * additional_per_person

      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types/#{buffet_type.id}/available", params: {date: Date.tomorrow, number_of_guests: 6}

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.keys.length).to eq 1
      expect(json_response["price"]).to eq price
    end

    it 'e número de pessoas não é informado' do
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
      buffet_type = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      BuffetTypePrice.create!(
        base_price_weekday: 10,
        additional_per_person_weekday: 10,
        additional_per_hour_weekday: 20,
        base_price_weekend: 20,
        additional_per_person_weekend: 20,
        additional_per_hour_weekend: 40,
        buffet_type: buffet_type
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types/#{buffet_type.id}/available", params: {date: Date.tomorrow}

      # Assert
      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.keys.length).to eq 1
      expect(json_response["error"]).to eq 'Número de pessoas não foi informado'
    end

    it 'e data não é informada' do
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
      buffet_type = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      BuffetTypePrice.create!(
        base_price_weekday: 10,
        additional_per_person_weekday: 10,
        additional_per_hour_weekday: 20,
        base_price_weekend: 20,
        additional_per_person_weekend: 20,
        additional_per_hour_weekend: 40,
        buffet_type: buffet_type
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types/#{buffet_type.id}/available", params: {number_of_guests: 6}

      # Assert
      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.keys.length).to eq 1
      expect(json_response["error"]).to eq 'Data não foi informada'
    end

    it 'e número de pessoas e data não foram informadas' do
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
      buffet_type = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      BuffetTypePrice.create!(
        base_price_weekday: 10,
        additional_per_person_weekday: 10,
        additional_per_hour_weekday: 20,
        base_price_weekend: 20,
        additional_per_person_weekend: 20,
        additional_per_hour_weekend: 40,
        buffet_type: buffet_type
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types/#{buffet_type.id}/available"

      # Assert
      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.keys.length).to eq 1
      expect(json_response["error"]).to eq 'Data e Número de pessoas não foram informados'
    end

    it 'e número de pessoas está abaixo no número mínimo de pessoas' do
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
      buffet_type = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      BuffetTypePrice.create!(
        base_price_weekday: 10,
        additional_per_person_weekday: 10,
        additional_per_hour_weekday: 20,
        base_price_weekend: 20,
        additional_per_person_weekend: 20,
        additional_per_hour_weekend: 40,
        buffet_type: buffet_type
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types/#{buffet_type.id}/available", params: {date: Date.tomorrow, number_of_guests: 4}

      # Assert
      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.keys.length).to eq 1
      expect(json_response["error"]).to eq "Número de pessoas está abaixo do mínimo de #{buffet_type.min_capacity_people}"
    end

    it 'e data não é futura' do
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
      buffet_type = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      BuffetTypePrice.create!(
        base_price_weekday: 10,
        additional_per_person_weekday: 10,
        additional_per_hour_weekday: 20,
        base_price_weekend: 20,
        additional_per_person_weekend: 20,
        additional_per_hour_weekend: 40,
        buffet_type: buffet_type
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types/#{buffet_type.id}/available", params: {date: Date.today, number_of_guests: 7}

      # Assert
      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.keys.length).to eq 1
      expect(json_response["error"]).to eq "Data precisa ser futura"
    end

    it 'e retorna erro se o id do buffet não existe' do
      # Act
      get "/api/v1/buffets/1/buffet_types/1/available", params: {date: Date.today, number_of_guests: 7}

      # Assert
      expect(response.status).to eq 404
    end

    it 'e retorna erro se o id do tipo de buffet não existe' do
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
      get "/api/v1/buffets/#{buffet.id}/buffet_types/1/available", params: {date: Date.today, number_of_guests: 7}

      # Assert
      expect(response.status).to eq 404
    end

    it 'e retorna erro se buffet_type não tem preço cadastrado' do
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
      buffet_type = BuffetType.create!(
        name: 'Casamento',
        description: 'Casamento com comida',
        max_capacity_people: 10,
        min_capacity_people: 5,
        duration: 120,
        menu: 'Comida caseira e doce',
        alcoholic_beverages: true,
        decoration: true,
        parking_valet: true,
        exclusive_address: true,
        buffet: buffet
      )
      # Act
      get "/api/v1/buffets/#{buffet.id}/buffet_types/#{buffet_type.id}/available", params: {date: Date.tomorrow, number_of_guests: 7}

      # Assert
      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.keys.length).to eq 1
      expect(json_response["error"]).to eq "Tipo de Buffet ainda não tem preço cadastrado"
    end
  end
end
