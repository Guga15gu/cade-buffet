require 'rails_helper'

describe 'Usuário Cliente vê seus pedidos' do
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

    Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Assert
    login_as client, :scope => :client
    visit root_path
    click_on 'Meus pedidos'

    # Assert
    expect(page).to have_content 'Buffet Delícias'
    expect(page).to have_content 7.day.from_now.strftime("%d/%m/%Y")
    expect(page).to have_link 'ABC12345'
  end

  it 'e não há nenhum' do
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

    # Assert
    login_as client, :scope => :client
    visit root_path
    click_on 'Meus pedidos'

    # Assert
    expect(page).to have_content 'Não há nenhum pedido.'
  end

  it 'e são vários e não vê pedidos de outros clientes' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')

    another_client = Client.create!(email: 't@email.com', password: 'password', name: 't', cpf:  '408.357.400-30')

    buffet_owner_user_a = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet_a = Buffet.create!(
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
      buffet_owner_user: buffet_owner_user_a
    )
    buffet_type_a = BuffetType.create!(
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
      buffet: buffet_a
    )
    BuffetTypePrice.create!(
      base_price_weekday: 10,
      additional_per_person_weekday: 11,
      additional_per_hour_weekday: 20,
      base_price_weekend: 21,
      additional_per_person_weekend: 30,
      additional_per_hour_weekend: 31,
      buffet_type: buffet_type_a
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    Order.create!(
      client: client,
      buffet: buffet_a,
      buffet_type: buffet_type_a,
      date: 7.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    buffet_owner_user_b = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
    buffet_b = Buffet.create!(
      business_name: 'Buffet Maravilhoso',
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
      buffet_owner_user: buffet_owner_user_b
    )
    buffet_type_b = BuffetType.create!(
      name: 'Festa',
      description: 'Festa com comida',
      max_capacity_people: 10,
      min_capacity_people: 5,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: buffet_b
    )
    BuffetTypePrice.create!(
      base_price_weekday: 10,
      additional_per_person_weekday: 11,
      additional_per_hour_weekday: 20,
      base_price_weekend: 21,
      additional_per_person_weekend: 30,
      additional_per_hour_weekend: 31,
      buffet_type: buffet_type_b
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('CDE12345')
    Order.create!(
      client: client,
      buffet: buffet_b,
      buffet_type: buffet_type_b,
      date: 8.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    buffet_owner_user_c = BuffetOwnerUser.create!(email: 'alex@email.com', password: 'password', name: 'alex')
    buffet_c = Buffet.create!(
      business_name: 'Buffet Celestial',
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
      buffet_owner_user: buffet_owner_user_c
    )
    buffet_type_c = BuffetType.create!(
      name: 'Restaurante',
      description: 'Restaurante com comida',
      max_capacity_people: 10,
      min_capacity_people: 5,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: buffet_c
    )
    BuffetTypePrice.create!(
      base_price_weekday: 10,
      additional_per_person_weekday: 11,
      additional_per_hour_weekday: 20,
      base_price_weekend: 21,
      additional_per_person_weekend: 30,
      additional_per_hour_weekend: 31,
      buffet_type: buffet_type_c
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('XYZ12345')
    Order.create!(
      client: another_client,
      buffet: buffet_c,
      buffet_type: buffet_type_c,
      date: 3.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Assert
    login_as client, :scope => :client
    visit root_path
    click_on 'Meus pedidos'

    # Assert
    expect(page).to have_content 'Buffet Delícias'
    expect(page).to have_content 7.day.from_now.strftime("%d/%m/%Y")
    expect(page).to have_link 'ABC12345'

    expect(page).to have_content 'Buffet Maravilhoso'
    expect(page).to have_content 8.day.from_now.strftime("%d/%m/%Y")
    expect(page).to have_link 'CDE12345'

    expect(page).not_to have_content 'Buffet Celestial'
    expect(page).not_to have_content 3.day.from_now.strftime("%d/%m/%Y")
    expect(page).not_to have_link 'XYZ12345'
  end

  it 'e não acha link para index do dono de buffet' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')

    # Act
    login_as client, :scope => :client
    visit root_path

    # Assert
    expect(page).not_to have_link 'Pedidos'
  end

  it 'e não acessa index de pedidos do dono de buffet' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')

    # Act
    login_as client, :scope => :client
    visit buffet_owner_user_index_orders_path

    # Assert
    expect(current_path).not_to eq buffet_owner_user_index_orders_path
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você precisa ser um dono de buffet para acessar seus pedidos como dono'
  end
end

describe 'Usuário Dono de Buffet vê seus pedidos' do
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

    Order.create!(
      client: client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_content 'Aguardando avaliação'
    expect(page).to have_content 'Buffet Delícias'
    expect(page).to have_content 7.day.from_now.strftime("%d/%m/%Y")
    expect(page).to have_link 'ABC12345'
  end

  it 'e não há nenhum' do
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
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_content 'Não há nenhum pedido.'

  end

  it 'e são vários e não vê pedidos de outros buffets' do
    # Arrange
    client_a = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')
    client_b = Client.create!(email: 'joao@email.com', password: 'password', name: 'Joao', cpf:  '408.357.400-30')

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
    buffet_type_a = BuffetType.create!(
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
      buffet_type: buffet_type_a
    )

    buffet_type_b = BuffetType.create!(
      name: 'Festa',
      description: 'Festa com comida',
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
      buffet_type: buffet_type_b
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('CDE12345')
    Order.create!(
      client: client_b,
      buffet: buffet,
      buffet_type: buffet_type_b,
      date: 10.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    Order.create!(
      client: client_a,
      buffet: buffet,
      buffet_type: buffet_type_a,
      date: 7.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    another_buffet_owner_user = BuffetOwnerUser.create!(email: 'alex@email.com', password: 'password', name: 'alex')
    another_buffet = Buffet.create!(
      business_name: 'Buffet Outro',
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
      buffet_owner_user: another_buffet_owner_user
    )
    another_buffet_type = BuffetType.create!(
      name: 'Gincana',
      description: 'Gincana com comida',
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
    BuffetTypePrice.create!(
      base_price_weekday: 10,
      additional_per_person_weekday: 11,
      additional_per_hour_weekday: 20,
      base_price_weekend: 21,
      additional_per_person_weekend: 30,
      additional_per_hour_weekend: 31,
      buffet_type: another_buffet_type
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('XYZ12345')
    Order.create!(
      client: client_b,
      buffet: another_buffet,
      buffet_type: another_buffet_type,
      date: 15.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'

    # Assert
    expect(page).to have_content 'Aguardando avaliação'
    expect(page).to have_content 'Buffet Delícias, Casamento'
    expect(page).to have_content 7.day.from_now.strftime("%d/%m/%Y")
    expect(page).to have_link 'ABC12345'

    expect(page).to have_content 'Buffet Delícias, Festa'
    expect(page).to have_content 10.day.from_now.strftime("%d/%m/%Y")
    expect(page).to have_link 'CDE12345'

    expect(page).not_to have_content 'Buffet Outro, Gincana'
    expect(page).not_to have_content 15.day.from_now.strftime("%d/%m/%Y")
    expect(page).not_to have_link 'XYZ12345'
  end

  it 'e não acha link para index do cliente' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path

    # Assert
    expect(page).not_to have_link 'Meus pedidos'
  end

  it 'e não acessa index de pedidos de cliente' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit client_index_orders_path

    # Assert
    expect(current_path).not_to eq client_index_orders_path
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você precisa ser um cliente para acessar seus pedidos como cliente'
  end

  it 'e vê pedidos separados por status' do
    # Arrange
    client_a = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')
    client_b = Client.create!(email: 'joao@email.com', password: 'password', name: 'Joao', cpf:  '408.357.400-30')

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
    buffet_type_a = BuffetType.create!(
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
      buffet_type: buffet_type_a
    )
    buffet_type_b = BuffetType.create!(
      name: 'Festa',
      description: 'Festa com comida',
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
      buffet_type: buffet_type_b
    )

    buffet_type_c = BuffetType.create!(
      name: 'Orquestra',
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
      buffet_type: buffet_type_c
    )
    buffet_type_d = BuffetType.create!(
      name: 'Show',
      description: 'Festa com comida',
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
      buffet_type: buffet_type_d
    )

    buffet_type_e = BuffetType.create!(
      name: 'Palestra',
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
      buffet_type: buffet_type_e
    )
    buffet_type_f = BuffetType.create!(
      name: 'Jogo de tenis',
      description: 'Festa com comida',
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
      buffet_type: buffet_type_f
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('PEN12345')
    Order.create!(
      client: client_a,
      buffet: buffet,
      buffet_type: buffet_type_a,
      date: 4.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('PEN6789')
    Order.create!(
      client: client_b,
      buffet: buffet,
      buffet_type: buffet_type_b,
      date: 5.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('CON12345')
    Order.create!(
      client: client_a,
      buffet: buffet,
      buffet_type: buffet_type_c,
      date: 7.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true,
      status: :confirmed
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('CON6789')
    Order.create!(
      client: client_b,
      buffet: buffet,
      buffet_type: buffet_type_d,
      date: 15.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true,
      status: :confirmed
    )

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('CAN12345')
    Order.create!(
      client: client_a,
      buffet: buffet,
      buffet_type: buffet_type_e,
      date: 19.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true,
      status: :canceled
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('CAN6789')
    Order.create!(
      client: client_b,
      buffet: buffet,
      buffet_type: buffet_type_f,
      date: 20.day.from_now,
      number_of_guests: 50,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true,
      status: :canceled
    )


    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'

    # Assert
    within('div#pending') do
      expect(page).to have_content 'Aguardando avaliação'
      expect(page).to have_content 'Buffet Delícias, Casamento'
      expect(page).to have_content 4.day.from_now.strftime("%d/%m/%Y")
      expect(page).to have_link 'PEN12345'
      expect(page).to have_content 'Buffet Delícias, Festa'
      expect(page).to have_content 5.day.from_now.strftime("%d/%m/%Y")
      expect(page).to have_link 'PEN6789'

      expect(page).not_to have_content 'Confirmados'
      expect(page).not_to have_content 'Buffet Delícias, Orquestra'
      expect(page).not_to have_content 7.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'CON12345'
      expect(page).not_to have_content 'Buffet Delícias, Show'
      expect(page).not_to have_content 15.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'CON6789'

      expect(page).not_to have_content 'Cancelados'
      expect(page).not_to have_content 'Buffet Delícias, Palestra'
      expect(page).not_to have_content 19.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'CAN12345'
      expect(page).not_to have_content 'Buffet Delícias, Jogo de tenis'
      expect(page).not_to have_content 20.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'CAN6789'
    end

    within('div#confirmed') do
      expect(page).to have_content 'Confirmados'
      expect(page).to have_content 'Buffet Delícias, Orquestra'
      expect(page).to have_content 7.day.from_now.strftime("%d/%m/%Y")
      expect(page).to have_link 'CON12345'
      expect(page).to have_content 'Buffet Delícias, Show'
      expect(page).to have_content 15.day.from_now.strftime("%d/%m/%Y")
      expect(page).to have_link 'CON6789'

      expect(page).not_to have_content 'Aguardando avaliação'
      expect(page).not_to have_content 'Buffet Delícias, Casamento'
      expect(page).not_to have_content 4.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'PEN12345'
      expect(page).not_to have_content 'Buffet Delícias, Festa'
      expect(page).not_to have_content 5.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'PEN6789'

      expect(page).not_to have_content 'Cancelados'
      expect(page).not_to have_content 'Buffet Delícias, Palestra'
      expect(page).not_to have_content 19.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'CAN12345'
      expect(page).not_to have_content 'Buffet Delícias, Jogo de tenis'
      expect(page).not_to have_content 20.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'CAN6789'
    end

    within('div#canceled') do
      expect(page).to have_content 'Cancelados'
      expect(page).to have_content 'Buffet Delícias, Palestra'
      expect(page).to have_content 19.day.from_now.strftime("%d/%m/%Y")
      expect(page).to have_link 'CAN12345'
      expect(page).to have_content 'Buffet Delícias, Jogo de tenis'
      expect(page).to have_content 20.day.from_now.strftime("%d/%m/%Y")
      expect(page).to have_link 'CAN6789'

      expect(page).not_to have_content 'Aguardando avaliação'
      expect(page).not_to have_content 'Buffet Delícias, Casamento'
      expect(page).not_to have_content 4.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'PEN12345'
      expect(page).not_to have_content 'Buffet Delícias, Festa'
      expect(page).not_to have_content 5.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'PEN6789'

      expect(page).not_to have_content 'Confirmados'
      expect(page).not_to have_content 'Buffet Delícias, Orquestra'
      expect(page).not_to have_content 7.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'CON12345'
      expect(page).not_to have_content 'Buffet Delícias, Show'
      expect(page).not_to have_content 15.day.from_now.strftime("%d/%m/%Y")
      expect(page).not_to have_link 'CON6789'
    end
  end
end

describe 'Usuário não autentificado vê pedidos' do
  it 'e não acha links' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Pedidos'
    expect(page).not_to have_link 'Meus pedidos'
  end

  it 'e não acessa index de pedidos do dono de buffet' do
    # Arrange

    # Act
    visit buffet_owner_user_index_orders_path

    # Assert
    expect(current_path).not_to eq buffet_owner_user_index_orders_path
    expect(current_path).to eq new_buffet_owner_user_session_path
    expect(page).to have_content 'Você precisa ser um dono de buffet para acessar pedidos'
  end

  it 'e não acessa index de pedidos do cliente' do
    # Arrange

    # Act
    visit client_index_orders_path

    # Assert
    expect(current_path).not_to eq client_index_orders_path
    expect(current_path).to eq new_client_session_path
    expect(page).to have_content 'Você precisa ser um cliente para acessar seus pedidos'
  end
end
