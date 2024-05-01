require 'rails_helper'

describe 'Usuário registra um buffet' do
  it 'e deve estar autenticado' do
    # Arrange
    BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    buffet = { :buffet => {
      business_name: 'Buffet Delícias',
      corporate_name: 'Empresa de Buffet Ltda',
      registration_number: '12345678901234',
      contact_phone: '(11) 1234-5678',
      address: 'Rua dos Sabores, 123',
      district: 'Centro',
      state: 'São Paulo',
      city: 'São Paulo',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos corporativos',
      payment_methods: 'Cartão de crédito, Dinheiro',
      }
    }

    # Act
    post(buffets_path, params: buffet)

    #Assert
    expect(response).to redirect_to(new_buffet_owner_user_session_path)
  end

  it 'e pode somente cadastrar um Buffet' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    Buffet.create!(
      business_name: 'Buffet Delícias',
      corporate_name: 'Empresa de Buffet Ltda',
      registration_number: '12345678901234',
      contact_phone: '(11) 1234-5678',
      address: 'Rua dos Sabores, 123',
      district: 'Centro',
      state: 'São Paulo',
      city: 'São Paulo',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos corporativos',
      payment_methods: 'Cartão de crédito, Dinheiro',
      buffet_owner_user: buffet_owner_user
    )
    second_buffet = { :buffet => {
      business_name: 'Buffet Trágico',
      corporate_name: 'Empresa de Trágedias Ltda',
      registration_number: '32145678901234',
      contact_phone: '(11) 9999-5678',
      address: 'Rua dos Rios, 1789',
      district: 'Ponta',
      state: 'São Jorge',
      city: 'São Jorge',
      postal_code: '12345-123',
      description: 'Buffet especializado em eventos esportivos',
      payment_methods: 'Cartão de crédito',
      }
    }

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    post(buffets_path, params: second_buffet)

    #Assert
    expect(response).to redirect_to(buffet_path(1))
  end

  it 'e somente cria na sua conta' do

  end
end
