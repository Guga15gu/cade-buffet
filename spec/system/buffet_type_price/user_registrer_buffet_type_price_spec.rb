require 'rails_helper'

describe 'Usuário cadastra um preço de tipo de buffet' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit new_buffet_type_price_path

    # Assert
    expect(current_path).not_to eq new_buffet_type_price_path
    expect(current_path).to eq new_buffet_owner_user_session_path
  end

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

    # Act
    login_as(buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Cadastrar preço'

    # Assert
    expect(page).to have_content 'Cadastrar preço'
    expect(current_path).to eq new_buffet_type_price_path
    expect(page).to have_field('Preço base em dia de semana')
    expect(page).to have_field('Adicional por pessoa em dia de semana')
    expect(page).to have_field('Adcional por hora em dia de semana')
    expect(page).to have_field('Preço base em fim de semana')
    expect(page).to have_field('Adicional por pessoa em fim de semana')
    expect(page).to have_field('Adicional por hora em fim de semana')
    expect(page).to have_button('Enviar')
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

    # Act
    login_as(buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Cadastrar preço'

    fill_in 'Preço base em dia de semana', with: '1000'
    fill_in 'Adicional por pessoa em dia de semana', with: '20'
    fill_in 'Adcional por hora em dia de semana', with: '300'
    fill_in 'Preço base em fim de semana', with: '2000'
    fill_in 'Adicional por pessoa em fim de semana', with: '45'
    fill_in 'Adicional por hora em fim de semana', with: '600'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Seu preço de Buffet foi cadastrado com sucesso!'
    expect(page).to have_content 'Preço base em dia de semana: 1000'
    expect(page).to have_content 'Adicional por pessoa em dia de semana: 20'
    expect(page).to have_content 'Adcional por hora em dia de semana: 300'
    expect(page).to have_content 'Preço base em fim de semana: 2000'
    expect(page).to have_content 'Adicional por pessoa em fim de semana: 45'
    expect(page).to have_content 'Adicional por hora em fim de semana: 600'
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

    # Act
    login_as(buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Cadastrar preço'

    fill_in 'Preço base em dia de semana', with: ''
    fill_in 'Adicional por pessoa em dia de semana', with: ''
    fill_in 'Adcional por hora em dia de semana', with: ''
    fill_in 'Preço base em fim de semana', with: ''
    fill_in 'Adicional por pessoa em fim de semana', with: ''
    fill_in 'Adicional por hora em fim de semana', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Seu preço de Buffet não foi cadastrado.'
    expect(page).to have_content 'Preço base em dia de semana não pode ficar em branco'
    expect(page).to have_content 'Adicional por pessoa em dia de semana não pode ficar em branco'
    expect(page).to have_content 'Adcional por hora em dia de semana não pode ficar em branco'
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

    # Act
    login_as(gustavo)
    visit new_buffet_type_price_path(buffet_type_id: joao_buffet_type.id)

    # Expect
    expect(current_path).not_to eq new_buffet_type_price_path(buffet_type_id: joao_buffet_type.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este tipo de buffet.'
  end

  it 'e pode somente cadastrar um' do
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
    login_as(buffet_owner_user)
    visit root_path
    click_on 'Casamento'

    # Expect
    expect(page).not_to have_link 'Cadastrar preço'
  end

  it 'e não consegue cadastrar um segundo preço de tipo de buffet' do
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
    login_as(buffet_owner_user)
    visit new_buffet_type_price_path(buffet_type_id: buffet_type.id)

    # Assert
    expect(current_path).not_to eq new_buffet_type_price_path
    expect(current_path).to eq buffet_type_price_path(buffet_type_price)
    expect(page).to have_content 'Tipo de buffet já tem um preço!'
  end
end
