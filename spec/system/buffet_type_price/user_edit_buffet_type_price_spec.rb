require 'rails_helper'

describe 'Usuário Dono de Buffet edita um preço de tipo de buffet' do
  it 'a partir da tela inicial' do
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
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Preço'
    click_on 'Editar preço'

    # Expect
    expect(page).to have_content 'Editar preço de tipo de Buffet'
    expect(page).to have_field 'Preço base em dia de semana', with: '10'
    expect(page).to have_field 'Adicional por pessoa em dia de semana', with: '10'
    expect(page).to have_field 'Adicional por hora em dia de semana', with: '20'
    expect(page).to have_field 'Preço base em fim de semana', with: '20'
    expect(page).to have_field 'Adicional por pessoa em fim de semana', with: '20'
    expect(page).to have_field 'Adicional por hora em fim de semana', with: '40'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
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
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Preço'
    click_on 'Editar preço'

    fill_in 'Preço base em dia de semana', with: '110'
    fill_in 'Adicional por pessoa em dia de semana', with: '111'
    fill_in 'Adicional por hora em dia de semana', with: '210'
    fill_in 'Preço base em fim de semana', with: '211'
    fill_in 'Adicional por pessoa em fim de semana', with: '300'
    fill_in 'Adicional por hora em fim de semana', with: '410'
    click_on 'Enviar'

    # Expect
    expect(page).to have_content 'Seu preço de tipo de Buffet foi editado com sucesso!'
    expect(page).to have_content 'Preço base em dia de semana: 110'
    expect(page).to have_content 'Adicional por pessoa em dia de semana: 111'
    expect(page).to have_content 'Adicional por hora em dia de semana: 210'
    expect(page).to have_content 'Preço base em fim de semana: 211'
    expect(page).to have_content 'Adicional por pessoa em fim de semana: 300'
    expect(page).to have_content 'Adicional por hora em fim de semana: 410'

  end

  it 'e mantém os campos obrigatórios' do
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
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Preço'
    click_on 'Editar preço'

    fill_in 'Preço base em dia de semana', with: ''
    fill_in 'Adicional por pessoa em dia de semana', with: ''
    fill_in 'Adicional por hora em dia de semana', with: ''
    fill_in 'Preço base em fim de semana', with: ''
    fill_in 'Adicional por pessoa em fim de semana', with: ''
    fill_in 'Adicional por hora em fim de semana', with: ''
    click_on 'Enviar'

    # Expect
    expect(page).to have_content 'Não foi possível atualizar o seu preço de tipo de Buffet'
    expect(page).to have_content 'Preço base em dia de semana não pode ficar em branco'
    expect(page).to have_content 'Adicional por pessoa em dia de semana não pode ficar em branco'
    expect(page).to have_content 'Adicional por hora em dia de semana não pode ficar em branco'
    expect(page).to have_content 'Preço base em fim de semana não pode ficar em branco'
    expect(page).to have_content 'Adicional por pessoa em fim de semana não pode ficar em branco'
    expect(page).to have_content 'Adicional por hora em fim de semana não pode ficar em branco'
  end

  it 'caso seja o dono' do
    # Arrange
    gustavo = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    joao = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'João')

    joao_buffet = Buffet.create!(
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
      buffet_owner_user: joao
    )
    gustavo_buffet = Buffet.create!(
      business_name: 'Buffet Redondo',
      corporate_name: 'Empresa de Circular Ltda',
      registration_number: '234236546',
      contact_phone: '(11) 32341-5678',
      address: 'Rua das Bolas, 000',
      district: 'Borda',
      state: 'Rio Grande do Sul',
      city: 'Pelotas',
      postal_code: '6774-678',
      description: 'Buffet especializado em comidas redondas',
      payment_methods: 'Dinheiro, Cheque',
      buffet_owner_user: gustavo
    )
    joao_buffet_type = BuffetType.create!(
      name: 'Casamento',
      description: 'Casamento com comida',
      max_capacity_people: 10,
      min_capacity_people: 5,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: false,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: joao_buffet
    )
    gustavo_buffet_type = BuffetType.create!(
      name: 'Casamento Líquido',
      description: 'Casamento com bebida',
      max_capacity_people: 100,
      min_capacity_people: 50,
      duration: 240,
      menu: 'Sopa',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: gustavo_buffet
    )
    joao_buffet_type_price = BuffetTypePrice.create!(
      base_price_weekday: 10,
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: joao_buffet_type
    )
    BuffetTypePrice.create!(
      base_price_weekday: 100,
      additional_per_person_weekday: 100,
      additional_per_hour_weekday: 200,
      base_price_weekend: 200,
      additional_per_person_weekend: 200,
      additional_per_hour_weekend: 400,
      buffet_type: gustavo_buffet_type
    )
    # Act
    login_as gustavo, :scope => :buffet_owner_user
    visit edit_buffet_type_price_path(joao_buffet_type_price)

    # Expect
    expect(current_path).not_to eq edit_buffet_type_price_path(joao_buffet_type)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este preço de tipo de buffet.'
  end

  it 'e volta para preço de tipo de buffet' do
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
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Preço'
    click_on 'Editar preço'
    click_on 'Voltar'

    # Expect
    expect(current_path).to eq buffet_type_path(buffet_type)
    expect(page).to have_content 'Nome: Casamento'
  end
end

describe 'Usuário não autentificado edita um preço de tipo de buffet' do
  it 'mas não acha link para editar' do
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
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    visit root_path
    click_on 'Buffet Delícias'
    click_on 'Casamento'
    click_on 'Preço'

    # Assert
    expect(page).not_to have_link('Editar preço')
  end

  it 'e não acessa formulário' do
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

    buffet_type_price = BuffetTypePrice.create!(
      base_price_weekday: 10,
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    visit edit_buffet_type_price_path(buffet_type_price)

    # Assert
    expect(current_path).not_to eq edit_buffet_type_price_path(buffet_type_price)
    expect(current_path).to eq buffet_owner_user_session_path
    expect(page).to have_content 'Você precisa ser usuário dono de buffet.'
  end
end

describe 'Usuário Cliente edita um preço de tipo de buffet' do
  it 'mas não acha link para editar' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  61445385007)

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
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    login_as client, :scope => :client
    visit root_path
    click_on 'Buffet Delícias'
    click_on 'Casamento'
    click_on 'Preço'

    # Assert
    expect(page).not_to have_link('Editar preço')
  end

  it 'e não acessa formulário' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  61445385007)

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
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    login_as client, :scope => :client
    visit edit_buffet_type_price_path(buffet_type_price)

    # Assert
    expect(current_path).not_to eq edit_buffet_type_price_path(buffet_type_price)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Clientes apenas podem visualizar buffet.'
  end
end
