require 'rails_helper'

describe 'Buffet API' do
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
      expect(json_response["id"]).to eq buffet.id
      expect(json_response["business_name"]).to eq 'Buffet Delícias'
      expect(json_response["contact_phone"]).to eq '(11) 1234-5678'
      expect(json_response["address"]).to eq 'Rua dos Sabores, 123'
      expect(json_response["district"]).to eq 'Centro'
      expect(json_response["state"]).to eq 'SP'
      expect(json_response["city"]).to eq 'São Paulo'
      expect(json_response["postal_code"]).to eq '12345-678'
      expect(json_response["description"]).to eq 'Buffet especializado em eventos corporativos'
      expect(json_response["payment_methods"]).to eq 'Cartão de crédito, Dinheiro'
      expect(json_response.keys.length).to eq 10

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

    it 'e ocorre erro interno' do
      # Arrange
      allow(Buffet).to receive(:find).and_raise(ActiveRecord::QueryCanceled)
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
      expect(response.status).to eq 500
    end
  end

  context 'GET /api/v1/buffets' do
    it 'e lista todos os buffets em ordem alfabética por nome' do
      # Arrange
      buffet_owner_user_a = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
      buffet_owner_user_b = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
      buffet_owner_user_c = BuffetOwnerUser.create!(email: 'cleber@email.com', password: 'password', name: 'Cleber')
      buffet_delicias = Buffet.create!(
        business_name: 'Delícias',
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
        buffet_owner_user: buffet_owner_user_a
      )
      buffet_alternativo = Buffet.create!(
        business_name: 'Alternativo',
        corporate_name: '2',
        registration_number: '2',
        contact_phone: '2',
        address: 'Rua dos dois, 2',
        district: 'Centro 2',
        state: 'RJ',
        city: 'Rio de Janeiro',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos divinos',
        payment_methods: 'Cheque',
        buffet_owner_user: buffet_owner_user_b
      )
      buffet_cleberaldo = Buffet.create!(
        business_name: 'Cleberaldo',
        corporate_name: '3',
        registration_number: '3',
        contact_phone: '3',
        address: 'Rua dos tres, 3',
        district: 'Centro 3',
        state: 'Santa Catarina',
        city: 'Florianópolis',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos cleberianos',
        payment_methods: 'Cartão',
        buffet_owner_user: buffet_owner_user_c
      )

      # Act
      get "/api/v1/buffets/"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 3

      expect(json_response[0]["id"]).to eq buffet_alternativo.id
      expect(json_response[0]["business_name"]).to eq 'Alternativo'
      expect(json_response[0]["contact_phone"]).to eq '2'
      expect(json_response[0]["address"]).to eq 'Rua dos dois, 2'
      expect(json_response[0]["district"]).to eq 'Centro 2'
      expect(json_response[0]["state"]).to eq 'RJ'
      expect(json_response[0]["city"]).to eq 'Rio de Janeiro'
      expect(json_response[0]["postal_code"]).to eq '12345-678'
      expect(json_response[0]["description"]).to eq 'Buffet especializado em eventos divinos'
      expect(json_response[0]["payment_methods"]).to eq 'Cheque'
      expect(json_response[0].keys.length).to eq 10
      expect(json_response[0].keys).not_to include "corporate_name"
      expect(json_response[0].keys).not_to include "registration_number"
      expect(json_response[0].keys).not_to include "created_at"
      expect(json_response[0].keys).not_to include "updated_at"

      expect(json_response[1]["id"]).to eq buffet_cleberaldo.id
      expect(json_response[1]["business_name"]).to eq 'Cleberaldo'
      expect(json_response[1]["contact_phone"]).to eq '3'
      expect(json_response[1]["address"]).to eq 'Rua dos tres, 3'
      expect(json_response[1]["district"]).to eq 'Centro 3'
      expect(json_response[1]["state"]).to eq 'Santa Catarina'
      expect(json_response[1]["city"]).to eq 'Florianópolis'
      expect(json_response[1]["postal_code"]).to eq '12345-678'
      expect(json_response[1]["description"]).to eq 'Buffet especializado em eventos cleberianos'
      expect(json_response[1]["payment_methods"]).to eq 'Cartão'
      expect(json_response[1].keys.length).to eq 10
      expect(json_response[1].keys).not_to include "corporate_name"
      expect(json_response[1].keys).not_to include "registration_number"
      expect(json_response[1].keys).not_to include "created_at"
      expect(json_response[1].keys).not_to include "updated_at"

      expect(json_response[2]["id"]).to eq buffet_delicias.id
      expect(json_response[2]["business_name"]).to eq 'Delícias'
      expect(json_response[2]["contact_phone"]).to eq '(11) 1234-5678'
      expect(json_response[2]["address"]).to eq 'Rua dos Sabores, 123'
      expect(json_response[2]["district"]).to eq 'Centro'
      expect(json_response[2]["state"]).to eq 'SP'
      expect(json_response[2]["city"]).to eq 'São Paulo'
      expect(json_response[2]["postal_code"]).to eq '12345-678'
      expect(json_response[2]["description"]).to eq 'Buffet especializado em eventos corporativos'
      expect(json_response[2]["payment_methods"]).to eq 'Cartão de crédito, Dinheiro'
      expect(json_response[2].keys.length).to eq 10

      expect(json_response[2].keys).not_to include "corporate_name"
      expect(json_response[2].keys).not_to include "registration_number"
      expect(json_response[2].keys).not_to include "created_at"
      expect(json_response[2].keys).not_to include "updated_at"
    end

    it 'e retorna vazio se não existe nenhum buffet' do
      # Arrange

      # Act
      get "/api/v1/buffets/"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 0
      expect(json_response).to eq []
    end

    it 'e ocorre erro interno' do
      # Arrange
      allow(Buffet).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
      buffet_delicias = Buffet.create!(
        business_name: 'Delícias',
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
      get "/api/v1/buffets/"

      # Assert
      expect(response.status).to eq 500
    end
  end

  context 'GET /api/v1/buffets?search=' do
    it 'e pesquisa por um nome com sucesso' do
      # Arrange
      buffet_owner_user_a = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
      buffet_owner_user_b = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
      buffet_owner_user_c = BuffetOwnerUser.create!(email: 'cleber@email.com', password: 'password', name: 'Cleber')

      buffet_alternativo = Buffet.create!(
        business_name: 'Alternativo',
        corporate_name: '2',
        registration_number: '2',
        contact_phone: '2',
        address: 'Rua dos dois, 2',
        district: 'Centro 2',
        state: 'RJ',
        city: 'Rio de Janeiro',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos divinos',
        payment_methods: 'Cheque',
        buffet_owner_user: buffet_owner_user_b
      )
      buffet_delicias = Buffet.create!(
        business_name: 'Delícias',
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
        buffet_owner_user: buffet_owner_user_a
      )
      buffet_cleberaldo = Buffet.create!(
        business_name: 'Cleberaldo',
        corporate_name: '3',
        registration_number: '3',
        contact_phone: '3',
        address: 'Rua dos tres, 3',
        district: 'Centro 3',
        state: 'Santa Catarina',
        city: 'Florianópolis',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos cleberianos',
        payment_methods: 'Cartão',
        buffet_owner_user: buffet_owner_user_c
      )

      # Act
      get "/api/v1/buffets/", params: {search: 'Del'}

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response[0]["id"]).to eq buffet_delicias.id
      expect(json_response[0]["business_name"]).to eq 'Delícias'
      expect(json_response[0]["contact_phone"]).to eq '(11) 1234-5678'
      expect(json_response[0]["address"]).to eq 'Rua dos Sabores, 123'
      expect(json_response[0]["district"]).to eq 'Centro'
      expect(json_response[0]["state"]).to eq 'SP'
      expect(json_response[0]["city"]).to eq 'São Paulo'
      expect(json_response[0]["postal_code"]).to eq '12345-678'
      expect(json_response[0]["description"]).to eq 'Buffet especializado em eventos corporativos'
      expect(json_response[0]["payment_methods"]).to eq 'Cartão de crédito, Dinheiro'
      expect(json_response[0].keys.length).to eq 10
    end

    it 'e pesquisa por um nome com sucesso, e encontra mais de um buffet em ordem alfabética' do
      # Arrange
      buffet_owner_user_a = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
      buffet_owner_user_b = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
      buffet_owner_user_c = BuffetOwnerUser.create!(email: 'cleber@email.com', password: 'password', name: 'Cleber')
      buffet_owner_user_d = BuffetOwnerUser.create!(email: 'rui@email.com', password: 'password', name: 'Rui')
      buffet_owner_user_e = BuffetOwnerUser.create!(email: 'bob@email.com', password: 'password', name: 'Bob')

      buffet_alternativo = Buffet.create!(
        business_name: 'Alternativo',
        corporate_name: '2',
        registration_number: '2',
        contact_phone: '2',
        address: 'Rua dos dois, 2',
        district: 'Centro 2',
        state: 'RJ',
        city: 'Rio de Janeiro',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos divinos',
        payment_methods: 'Cheque',
        buffet_owner_user: buffet_owner_user_b
      )
      buffet_zs_delicias = Buffet.create!(
        business_name: 'Zs Delícias',
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
        buffet_owner_user: buffet_owner_user_a
      )
      buffet_a_delu_do_norte = Buffet.create!(
        business_name: 'A Delu do norte',
        corporate_name: '9',
        registration_number: '9',
        contact_phone: '9',
        address: 'Rua dos 9, 9',
        district: 'Praça 9',
        state: 'RN',
        city: 'Natal',
        postal_code: '32145-986',
        description: 'Buffet especializado em eventos do norte',
        payment_methods: 'Dinheiro em papel',
        buffet_owner_user: buffet_owner_user_e
      )
      buffet_cleberaldo = Buffet.create!(
        business_name: 'Cleberaldo',
        corporate_name: '3',
        registration_number: '3',
        contact_phone: '3',
        address: 'Rua dos tres, 3',
        district: 'Centro 3',
        state: 'Santa Catarina',
        city: 'Florianópolis',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos cleberianos',
        payment_methods: 'Cartão',
        buffet_owner_user: buffet_owner_user_c
      )
      buffet_buffet_ardelulios_sul = Buffet.create!(
        business_name: 'Buffet ardelulios sul',
        corporate_name: '5',
        registration_number: '5',
        contact_phone: '5',
        address: 'Rua dos 5, 5',
        district: 'Praça 3',
        state: 'Alagoas',
        city: 'Maceió',
        postal_code: '12345-986',
        description: 'Buffet especializado em eventos ardentes',
        payment_methods: 'Cartão débito',
        buffet_owner_user: buffet_owner_user_d
      )

      # Act
      get "/api/v1/buffets/", params: {search: 'Del'}

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 3

      expect(json_response[0]["id"]).to eq buffet_a_delu_do_norte.id
      expect(json_response[0]["business_name"]).to eq 'A Delu do norte'
      expect(json_response[0]["contact_phone"]).to eq '9'
      expect(json_response[0]["address"]).to eq 'Rua dos 9, 9'
      expect(json_response[0]["district"]).to eq 'Praça 9'
      expect(json_response[0]["state"]).to eq 'RN'
      expect(json_response[0]["city"]).to eq 'Natal'
      expect(json_response[0]["postal_code"]).to eq '32145-986'
      expect(json_response[0]["description"]).to eq 'Buffet especializado em eventos do norte'
      expect(json_response[0]["payment_methods"]).to eq 'Dinheiro em papel'
      expect(json_response[0].keys.length).to eq 10

      expect(json_response[1]["id"]).to eq buffet_buffet_ardelulios_sul.id
      expect(json_response[1]["business_name"]).to eq 'Buffet ardelulios sul'
      expect(json_response[1]["contact_phone"]).to eq '5'
      expect(json_response[1]["address"]).to eq 'Rua dos 5, 5'
      expect(json_response[1]["district"]).to eq 'Praça 3'
      expect(json_response[1]["state"]).to eq 'Alagoas'
      expect(json_response[1]["city"]).to eq 'Maceió'
      expect(json_response[1]["postal_code"]).to eq '12345-986'
      expect(json_response[1]["description"]).to eq 'Buffet especializado em eventos ardentes'
      expect(json_response[1]["payment_methods"]).to eq 'Cartão débito'
      expect(json_response[1].keys.length).to eq 10

      expect(json_response[2]["id"]).to eq buffet_zs_delicias.id
      expect(json_response[2]["business_name"]).to eq 'Zs Delícias'
      expect(json_response[2]["contact_phone"]).to eq '(11) 1234-5678'
      expect(json_response[2]["address"]).to eq 'Rua dos Sabores, 123'
      expect(json_response[2]["district"]).to eq 'Centro'
      expect(json_response[2]["state"]).to eq 'SP'
      expect(json_response[2]["city"]).to eq 'São Paulo'
      expect(json_response[2]["postal_code"]).to eq '12345-678'
      expect(json_response[2]["description"]).to eq 'Buffet especializado em eventos corporativos'
      expect(json_response[2]["payment_methods"]).to eq 'Cartão de crédito, Dinheiro'
      expect(json_response[2].keys.length).to eq 10
    end

    it 'e pesquisa por um nome, mas não encontra nenhum buffet' do
      # Arrange
      buffet_owner_user_a = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
      buffet_owner_user_b = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
      buffet_owner_user_c = BuffetOwnerUser.create!(email: 'cleber@email.com', password: 'password', name: 'Cleber')

      buffet_b = Buffet.create!(
        business_name: 'Alternativo',
        corporate_name: '2',
        registration_number: '2',
        contact_phone: '2',
        address: 'Rua dos dois, 2',
        district: 'Centro 2',
        state: 'RJ',
        city: 'Rio de Janeiro',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos divinos',
        payment_methods: 'Cheque',
        buffet_owner_user: buffet_owner_user_b
      )
      buffet_a = Buffet.create!(
        business_name: 'Delícias',
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
        buffet_owner_user: buffet_owner_user_a
      )
      buffet_c = Buffet.create!(
        business_name: 'Cleberaldo',
        corporate_name: '3',
        registration_number: '3',
        contact_phone: '3',
        address: 'Rua dos tres, 3',
        district: 'Centro 3',
        state: 'Santa Catarina',
        city: 'Florianópolis',
        postal_code: '12345-678',
        description: 'Buffet especializado em eventos cleberianos',
        payment_methods: 'Cartão',
        buffet_owner_user: buffet_owner_user_c
      )

      # Act
      get "/api/v1/buffets/", params: {search: 'Não'}

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 0
      expect(json_response).to eq []
    end

    it 'e ocorre erro interno' do
      # Arrange
      allow(Buffet).to receive(:where).and_raise(ActiveRecord::QueryCanceled)
      buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

      buffet_delicias = Buffet.create!(
        business_name: 'Delícias',
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
      get "/api/v1/buffets/", params: {search: 'Del'}

      # Assert
      expect(response.status).to eq 500
    end
  end

end
