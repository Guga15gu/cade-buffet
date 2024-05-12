require 'rails_helper'

describe 'Usuário Dono de Buffet avalia um pedido' do
  it 'e vê botões para confirmar e cancelar num pedido pendente' do
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
    order = Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit order_path(order)

    # Assert
    expect(page).to have_button 'Confirmar Pedido'
    expect(page).to have_button 'Cancelar Pedido'
  end

  it 'e não vê botões para confirmar e cancelar num pedido já confirmado' do
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
    order = Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    order.confirmed!

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit order_path(order)

    # Assert
    expect(page).not_to have_button 'Confirmar Pedido'
    expect(page).not_to have_button 'Cancelar Pedido'
  end

  it 'e não vê botões para confirmar e cancelar num pedido já cancelado' do
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
    order = Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    order.canceled!

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit order_path(order)

    # Assert
    expect(page).not_to have_button 'Confirmar Pedido'
    expect(page).not_to have_button 'Cancelar Pedido'
  end

  it 'e confirma o pedido' do
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
    Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'
    click_on 'ABC12345'
    click_on 'Confirmar Pedido'

    # Assert
    expect(page).to have_content 'Pedido Confirmado com sucesso!'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Status: Confirmado'
    expect(page).to have_content 'Cliente: Gustavo, gustavo@email.com'
    expect(page).to have_content 'Tipo de Evento: Casamento'
    expect(page).to have_content 'Quantidade estimada de convidados: 7'
    expect(page).to have_content 'Detalhes do Evento: Sem mais detalhes'
    expect(page).to have_content 'Local Próprio: Rua Joao, 50'
  end

  it 'e cancela o pedido' do
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
    Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'
    click_on 'ABC12345'
    click_on 'Cancelar Pedido'

    # Assert
    expect(page).to have_content 'Pedido Cancelado com sucesso!'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Status: Cancelado'
    expect(page).to have_content 'Cliente: Gustavo, gustavo@email.com'
    expect(page).to have_content 'Tipo de Evento: Casamento'
    expect(page).to have_content 'Quantidade estimada de convidados: 7'
    expect(page).to have_content 'Detalhes do Evento: Sem mais detalhes'
    expect(page).to have_content 'Local Próprio: Rua Joao, 50'
  end
end

describe 'Usuário Cliente avalia um pedido' do
  it 'e não vê botões para confirmar e cancelar num pedido pendente' do
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
    order = Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Act
    login_as client, :scope => :client
    visit order_path(order)

    # Assert
    expect(page).not_to have_button 'Confirmar Pedido'
    expect(page).not_to have_button 'Cancelar Pedido'
  end

  it 'e não vê botões para confirmar e cancelar num pedido já confirmado' do
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
    order = Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    order.confirmed!

    # Act
    login_as client, :scope => :client
    visit order_path(order)

    # Assert
    expect(page).not_to have_button 'Confirmar Pedido'
    expect(page).not_to have_button 'Cancelar Pedido'
  end

  it 'e não vê botões para confirmar e cancelar num pedido já cancelado' do
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
    order = Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    order.canceled!

    # Act
    login_as client, :scope => :client
    visit order_path(order)

    # Assert
    expect(page).not_to have_button 'Confirmar Pedido'
    expect(page).not_to have_button 'Cancelar Pedido'
  end
end
