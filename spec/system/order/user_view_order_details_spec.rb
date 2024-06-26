require 'rails_helper'

describe 'Usuário Dono de Buffet vê um pedido' do
  it 'com sucesso e com local próprio' do
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

    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'
    click_on 'ABC12345'

    # Assert
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Status: Aguardando avaliação do dono do buffet'
    expect(page).to have_content 'Cliente: Gustavo, gustavo@email.com'
    expect(page).to have_content 'Tipo de Evento: Casamento'
    expect(page).to have_content 'Quantidade estimada de convidados: 7'
    expect(page).to have_content 'Detalhes do Evento: Sem mais detalhes'
    expect(page).to have_content 'Local Próprio: Rua Joao, 50'
  end

  it 'com sucesso e sem local próprio' do
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
      has_custom_address: false
    )

    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'
    click_on 'ABC12345'

    # Assert
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Status: Aguardando avaliação do dono do buffet'
    expect(page).to have_content 'Cliente: Gustavo, gustavo@email.com'
    expect(page).to have_content 'Tipo de Evento: Casamento'
    expect(page).to have_content 'Quantidade estimada de convidados: 7'
    expect(page).to have_content 'Detalhes do Evento: Sem mais detalhes'
    expect(page).to have_content 'Sem Local Próprio: Na localização do buffet'
  end

  it 'e acessa buffet' do
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

    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'
    click_on 'ABC12345'
    click_on 'Buffet Delícias'

    # Assert
    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content 'Buffet Delícias'
  end

  it 'e acessa tipo de buffet' do
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

    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path
    click_on 'Pedidos'
    click_on 'ABC12345'
    click_on 'Casamento'

    # Assert
    expect(current_path).to eq buffet_type_path(buffet_type)
    expect(page).to have_content 'Casamento'
  end

  it 'e tenta acessar pedido de outro dono de buffet' do
    # Arrange
    client = Client.create!(email: 'joa@email.com', password: 'password', name: 'Joao', cpf:  '408.357.400-30')

    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    another_buffet_owner_user = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')

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
      buffet_owner_user: another_buffet_owner_user
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

    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit order_path(order)

    # Assert
    expect(current_path).not_to eq order_path(order)
    expect(current_path).to eq buffet_owner_user_index_orders_path
    expect(page).to have_content 'Você não possui acesso a este pedido.'
  end

  it 'e existe outro pedido no mesmo dia' do
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
    order_a = Order.create!(
      client: client_a,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC6789')
    Order.create!(
      client: client_b,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 8,
      address: 'Rua Joao, 34',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Assert
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit order_path(order_a)

    # Assert
    within('div#others_orders') do
      expect(page).to have_content 'Há outros pedidos no mesmo dia:'
      within('li') do
        expect(page).to have_content 'Pedido ABC6789'
        expect(page).to have_link 'ABC6789'
      end

    end
    expect(page).to have_content 'Pedido ABC12345'
  end

  it 'e link do outro pedido funciona' do
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
    order_a = Order.create!(
      client: client_a,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC6789')
    order_b = Order.create!(
      client: client_b,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 8,
      address: 'Rua Joao, 34',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit order_path(order_a)
    within('div#others_orders') do
      within('li') do
        click_on 'ABC6789'
      end
    end
    expect(current_path).to eq order_path(order_b)
  end
end

describe 'Usuário Cliente vê um pedido' do
  it 'com sucesso e com local próprio' do
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

    # Assert
    login_as client, :scope => :client
    visit root_path
    click_on 'Meus pedidos'
    click_on 'ABC12345'

    # Assert
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Status: Aguardando avaliação do dono do buffet'
    expect(page).to have_content 'Cliente: Gustavo, gustavo@email.com'
    expect(page).to have_content 'Tipo de Evento: Casamento'
    expect(page).to have_content 'Quantidade estimada de convidados: 7'
    expect(page).to have_content 'Detalhes do Evento: Sem mais detalhes'
    expect(page).to have_content 'Local Próprio: Rua Joao, 50'
  end

  it 'com sucesso e sem local próprio' do
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
      has_custom_address: false
    )

    # Assert
    login_as client, :scope => :client
    visit root_path
    click_on 'Meus pedidos'
    click_on 'ABC12345'

    # Assert
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Status: Aguardando avaliação do dono do buffet'
    expect(page).to have_content 'Cliente: Gustavo, gustavo@email.com'
    expect(page).to have_content 'Tipo de Evento: Casamento'
    expect(page).to have_content 'Quantidade estimada de convidados: 7'
    expect(page).to have_content 'Detalhes do Evento: Sem mais detalhes'
    expect(page).to have_content 'Sem Local Próprio: Na localização do buffet'
  end

  it 'e tenta acessar pedido de outro cliente' do
    # Arrange
    another_client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')

    client = Client.create!(email: 'joa@email.com', password: 'password', name: 'Joao', cpf:  '408.357.400-30')

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
      client: another_client,
      buffet: buffet,
      buffet_type: buffet_type,
      date: 7.day.from_now,
      number_of_guests: 7,
      address: 'Rua Joao, 50',
      event_details: 'Sem mais detalhes',
      has_custom_address: true
    )

    # Assert
    login_as client, :scope => :client
    visit order_path(order)

    # Assert
    expect(current_path).not_to eq order_path(order)
    expect(current_path).to eq client_index_orders_path
    expect(page).to have_content 'Você não possui acesso a este pedido.'
  end
end

describe 'Usuário não autentificado vê pedido' do
  it 'e não tem acesso a rota' do
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

    # Assert
    visit order_path(order)

    # Assert
    expect(current_path).not_to eq order_path(order)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você precisa estar logado para acessar um pedido'
  end
end
