require 'rails_helper'

describe 'Usuário Dono de Buffet vê um tipo de buffet' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(current_path).not_to have_content 'Tipos de Buffet'
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
      max_capacity_people: 100,
      min_capacity_people: 1,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: false,
      buffet: buffet
    )

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'

    # Expect
    expect(current_path).to eq buffet_type_path(buffet_type)
    expect(page).to have_content 'Tipo de Buffet'
    expect(page).to have_content 'Nome: Casamento'
    expect(page).to have_content 'Descrição: Casamento com comida'
    expect(page).to have_content('Quantidade máxima de pessoas: 100 pessoas')
    expect(page).to have_content('Quantidade mínima de pessoas: 1 pessoa')
    expect(page).to have_content('Duração: 120 minutos')
    expect(page).to have_content('Cardápio: Comida caseira e doce')
    expect(page).to have_content('Bebidas alcoólicas: Disponível')
    expect(page).to have_content('Decoração: Disponível')
    expect(page).to have_content('Serviço de estacionamento: Disponível')
    expect(page).to have_content('Endereço exclusivo: Indisponível')
  end

  it 'e volta para tela inicial pelo Home' do
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
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit buffet_type_path(buffet_type)
    click_on 'Home'

    # Expect
    expect(current_path).to eq root_path
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
    BuffetType.create!(
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
    login_as gustavo, :scope => :buffet_owner_user
    visit buffet_type_path(joao_buffet_type)

    # Expect
    expect(current_path).not_to eq buffet_type_path(joao_buffet_type)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este tipo de Buffet.'
  end

  it 'e volta para tela inicial' do
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

    BuffetType.create!(
      name: 'Casamento',
      description: 'Casamento com comida',
      max_capacity_people: 100,
      min_capacity_people: 1,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: false,
      buffet: buffet
    )

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Voltar'
    expect(current_path).to eq root_path
  end
end

describe 'Usuário não autentificado vê um tipo de buffet' do
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
      max_capacity_people: 100,
      min_capacity_people: 1,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: false,
      buffet: buffet
    )

    # Act
    visit(root_path)
    click_on 'Buffet Delícias'
    click_on 'Casamento'

    # Assert
    # Expect
    expect(current_path).to eq buffet_type_path(buffet_type)
    expect(page).to have_content 'Tipo de Buffet'
    expect(page).to have_content 'Nome: Casamento'
    expect(page).to have_content 'Descrição: Casamento com comida'
    expect(page).to have_content('Quantidade máxima de pessoas: 100 pessoas')
    expect(page).to have_content('Quantidade mínima de pessoas: 1 pessoa')
    expect(page).to have_content('Duração: 120 minutos')
    expect(page).to have_content('Cardápio: Comida caseira e doce')
    expect(page).to have_content('Bebidas alcoólicas: Disponível')
    expect(page).to have_content('Decoração: Disponível')
    expect(page).to have_content('Serviço de estacionamento: Disponível')
    expect(page).to have_content('Endereço exclusivo: Indisponível')
  end

  it 'e não vê botão editar' do
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
      max_capacity_people: 100,
      min_capacity_people: 1,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: false,
      buffet: buffet
    )

    # Act
    visit(root_path)
    click_on 'Buffet Delícias'
    click_on 'Casamento'

    # Assert
    expect(current_path).to eq buffet_type_path(buffet_type)
    expect(page).not_to have_link 'Editar tipo de Buffet'
  end
end

describe 'Usuário Cliente vê um tipo de buffet' do
  it 'a partir da tela inicial' do
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
      max_capacity_people: 100,
      min_capacity_people: 1,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: false,
      buffet: buffet
    )

    # Act
    login_as client, :scope => :client
    visit(root_path)
    click_on 'Buffet Delícias'
    click_on 'Casamento'

    # Assert
    # Expect
    expect(current_path).to eq buffet_type_path(buffet_type)
    expect(page).to have_content 'Tipo de Buffet'
    expect(page).to have_content 'Nome: Casamento'
    expect(page).to have_content 'Descrição: Casamento com comida'
    expect(page).to have_content('Quantidade máxima de pessoas: 100 pessoas')
    expect(page).to have_content('Quantidade mínima de pessoas: 1 pessoa')
    expect(page).to have_content('Duração: 120 minutos')
    expect(page).to have_content('Cardápio: Comida caseira e doce')
    expect(page).to have_content('Bebidas alcoólicas: Disponível')
    expect(page).to have_content('Decoração: Disponível')
    expect(page).to have_content('Serviço de estacionamento: Disponível')
    expect(page).to have_content('Endereço exclusivo: Indisponível')
  end

  it 'e não vê botão editar' do
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
      max_capacity_people: 100,
      min_capacity_people: 1,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: false,
      buffet: buffet
    )

    # Act
    login_as client, :scope => :client
    visit(root_path)
    click_on 'Buffet Delícias'
    click_on 'Casamento'

    # Assert
    expect(current_path).to eq buffet_type_path(buffet_type)
    expect(page).not_to have_link 'Editar tipo de Buffet'
  end
end
