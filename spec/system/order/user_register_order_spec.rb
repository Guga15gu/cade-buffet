require 'rails_helper'

describe 'Usuário Cliente faz um pedido' do
  it 'com sucesso' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')

    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet = Buffet.create!(
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
      additional_per_person_weekday: 11,
      additional_per_hour_weekday: 20,
      base_price_weekend: 21,
      additional_per_person_weekend: 30,
      additional_per_hour_weekend: 31,
      buffet_type: buffet_type
    )

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    # Assert
    login_as client, :scope => :client
    visit root_path
    click_on 'Buffet Delícias'
    click_on 'Fazer Pedido'

    select 'Casamento', from: 'Tipo de evento'
    fill_in 'Data desejada', with: '29/05/2025'
    fill_in 'Quantidade estimada de convidados', with: '7'
    fill_in 'Detalhes do Evento', with: 'Big evento'
    select 'Sim', from: 'Endereço próprio'
    fill_in 'Endereço próprio desejado para o evento', with: 'Joao andrada 50'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Pedido feito com sucesso, aguardando análise do Buffet.'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Buffet: Buffet Delícias'
    expect(page).to have_content 'Tipo de Evento: Casamento'
    expect(page).to have_content 'Data desejada: 29/05/2025'
    expect(page).to have_content 'Status: Aguardando avaliação do dono do buffet'
    expect(page).to have_content 'Quantidade estimada de convidados: 7'
    expect(page).to have_content 'Detalhes do Evento: Big evento'
    expect(page).to have_content 'Local Próprio: Joao andrada 50'
  end

  it 'e recebe erros' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')

    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet = Buffet.create!(
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
      additional_per_person_weekday: 11,
      additional_per_hour_weekday: 20,
      base_price_weekend: 21,
      additional_per_person_weekend: 30,
      additional_per_hour_weekend: 31,
      buffet_type: buffet_type
    )

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    # Assert
    login_as client, :scope => :client
    visit root_path
    click_on 'Buffet Delícias'
    click_on 'Fazer Pedido'

    select 'Casamento', from: 'Tipo de evento'
    fill_in 'Data desejada', with: ''
    fill_in 'Quantidade estimada de convidados', with: ''
    fill_in 'Detalhes do Evento', with: ''
    select 'Sim', from: 'Endereço próprio'
    fill_in 'Endereço próprio desejado para o evento', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Seu pedido não foi cadastrado.'
    expect(page).to have_content 'Quantidade estimada de convidados não pode ficar em branco'
    expect(page).to have_content 'Data não pode ficar em branco'
    expect(page).to have_content 'Detalhes do Evento não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(current_path).to eq orders_path
  end
end

describe 'Usuário Dono de Buffet faz um pedido' do
  it 'e não tem acesso a rota' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet = Buffet.create!(
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
      additional_per_person_weekday: 11,
      additional_per_hour_weekday: 20,
      base_price_weekend: 21,
      additional_per_person_weekend: 30,
      additional_per_hour_weekend: 31,
      buffet_type: buffet_type
    )

    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit new_order_path

    # Assert
    expect(current_path).not_to eq new_order_path
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você precisa ser um cliente para acessar seus pedidos'
  end
end

describe 'Usuário não autentificado faz um pedido' do
  it 'e não tem acesso a rota' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet = Buffet.create!(
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
      additional_per_person_weekday: 11,
      additional_per_hour_weekday: 20,
      base_price_weekend: 21,
      additional_per_person_weekend: 30,
      additional_per_hour_weekend: 31,
      buffet_type: buffet_type
    )

    # Assert
    visit new_order_path

    # Assert
    expect(current_path).not_to eq new_order_path
    expect(current_path).to eq new_client_session_path
    expect(page).to have_content 'Você precisa ser um cliente para acessar seus pedidos'
  end
end
