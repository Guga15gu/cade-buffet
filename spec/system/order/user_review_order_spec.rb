require 'rails_helper'

describe 'Usuário Dono de Buffet avalia um pedido' do
  it 'e vê botões para aprovar e cancelar num pedido pendente' do
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
    expect(page).to have_button 'Aprovar Pedido'
    expect(page).to have_button 'Cancelar Pedido'
  end

  it 'e não vê botões para aprovar e cancelar num pedido já confirmado' do
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
    order.update!(
      tax_or_discount: 10,
      description_tax_or_discount: 'blabla bla',
      payment_method: 'cartao',
      payment_date: 3.days.from_now
    )
    order.approved_by_buffet_owner!

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit order_path(order)

    # Assert
    expect(page).not_to have_button 'Aprovar Pedido'
    expect(page).not_to have_button 'Cancelar Pedido'
  end

  it 'e não vê botões para aprovar e cancelar num pedido já cancelado' do
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
    expect(page).not_to have_button 'Aprovar Pedido'
    expect(page).not_to have_button 'Cancelar Pedido'
  end

  it 'e vê campos para preencher, para aprovar pedido' do
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
    buffet_type_price = BuffetTypePrice.create!(
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

    if order.date.on_weekday?
      base_price = buffet_type_price.base_price_weekday
      additional_per_person = buffet_type_price.additional_per_person_weekday
    else
      base_price = buffet_type_price.base_price_weekend
      additional_per_person = buffet_type_price.additional_per_person_weekend
    end
    extra_people = order.number_of_guests - buffet_type.min_capacity_people
    price = base_price + extra_people * additional_per_person

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit order_path(order)

    # Assert
    expect(page).to have_button 'Aprovar Pedido'
    expect(page).to have_content "Valor final em R$: #{price}"
    expect(page).to have_content 'Taxa extra ou desconto:'
    expect(page).to have_field 'Taxa extra ou desconto'
    expect(page).to have_content 'Descrição da taxa extra ou desconto:'
    expect(page).to have_field 'Descrição da taxa extra ou desconto'
    expect(page).to have_content 'Meio de pagamento:'
    expect(page).to have_field 'Meio de pagamento:'
    expect(page).to have_content 'Data de validade do valor atual:'
    expect(page).to have_field 'Data de validade do valor atual'

    expect(page).to have_button 'Cancelar Pedido'
  end

  it 'e aprova o pedido' do
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

    fill_in 'Taxa extra ou desconto', with: '10'
    fill_in 'Descrição da taxa extra ou desconto', with: 'taxa do dia'
    fill_in 'Meio de pagamento', with: 'Cartão de crédito'
    fill_in 'Data de validade do valor atual', with: 3.days.from_now
    click_on 'Aprovar Pedido'

    # Assert
    expect(page).to have_content 'Pedido Aprovado com sucesso, esperando confirmação do cliente!'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Status: Aprovado pelo Dono do Buffet'
    expect(page).to have_content 'Cliente: Gustavo, gustavo@email.com'
    expect(page).to have_content 'Tipo de Evento: Casamento'
    expect(page).to have_content 'Quantidade estimada de convidados: 7'
    expect(page).to have_content 'Detalhes do Evento: Sem mais detalhes'
    expect(page).to have_content 'Local Próprio: Rua Joao, 50'

    expect(page).to have_content 'Taxa extra ou desconto: 10'
    expect(page).to have_content 'Descrição da taxa extra ou desconto: taxa do dia'
    expect(page).to have_content 'Meio de pagamento: Cartão de crédito'
    expect(page).to have_content "Data de validade do valor atual: #{3.days.from_now.strftime("%d/%m/%Y")}"
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
    order.tax_or_discount = 10
    order.description_tax_or_discount = 'taxa do dia'
    order.payment_method = 'Dinheiro'
    order.payment_date = 3.days.from_now
    order.save!
    order.approved_by_buffet_owner!

    # Act
    login_as client, :scope => :client
    visit order_path(order)

    # Assert
    expect(page).not_to have_button 'Aprovar Pedido'
    expect(page).not_to have_button 'Cancelar Pedido'
  end

  it 'e vê botão e dia máximo para confirmar pedido aprovado pelo dono do Buffet' do
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
    order.tax_or_discount = 10
    order.description_tax_or_discount = 'taxa do dia'
    order.payment_method = 'Dinheiro'
    order.payment_date = 3.days.from_now
    order.save!
    order.approved_by_buffet_owner!

    # Act
    login_as client, :scope => :client
    visit order_path(order)

    # Assert
    expect(page).to have_content 'Taxa extra ou desconto: 10'
    expect(page).to have_content 'Descrição da taxa extra ou desconto: taxa do dia'
    expect(page).to have_content 'Meio de pagamento: Dinheiro'
    expect(page).to have_content "Data de validade do valor atual: #{3.days.from_now.strftime("%d/%m/%Y")}"

    expect(page).not_to have_content 'Data máxima para aprovar o pedido foi excedida!. Não é mais possível aprovar o pedido.'
    expect(page).to have_button 'Confirmar Pedido'
  end

  it 'e confirma pedido aprovado pelo dono do Buffet' do
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
    order.tax_or_discount = 10
    order.description_tax_or_discount = 'taxa do dia'
    order.payment_method = 'Dinheiro'
    order.payment_date = 3.days.from_now
    order.save!
    order.approved_by_buffet_owner!

    # Act
    login_as client, :scope => :client
    visit order_path(order)
    click_on 'Confirmar Pedido'

    # Assert
    expect(page).to have_content 'Pedido Confirmado com sucesso! O buffet será realizado!'
    expect(page).to have_content 'Status: Pedido Confirmado pelo Cliente.'
  end

  it 'e já passou data limite para confirmar pedido' do
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
    order.tax_or_discount = 10
    order.description_tax_or_discount = 'taxa do dia'
    order.payment_method = 'Dinheiro'
    order.payment_date = 1.days.ago
    order.save!
    order.approved_by_buffet_owner!

    # Act
    login_as client, :scope => :client
    visit order_path(order)

    # Assert
    expect(page).to have_content 'Data máxima para aprovar o pedido foi excedida!. Não é mais possível aprovar o pedido.'
    expect(page).not_to have_button 'Confirmar Pedido'
  end
end
