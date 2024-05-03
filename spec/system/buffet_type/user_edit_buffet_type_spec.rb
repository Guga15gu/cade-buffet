require 'rails_helper'

describe 'Usuário Dono de Buffet edita um tipo de buffet' do
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
    BuffetType.create!(
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
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Editar'

    # Assert
    expect(page).to have_content 'Editar tipo de Buffet'
    expect(page).to have_field 'Nome', with: 'Casamento'
    expect(page).to have_field 'Descrição', with: 'Casamento com comida'
    expect(page).to have_field 'Quantidade máxima de pessoas', with: '10'
    expect(page).to have_field 'Quantidade mínima de pessoas', with: '5'
    expect(page).to have_field 'Duração', with: '120'
    expect(page).to have_field 'Cardápio', with: 'Comida caseira e doce'
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
    BuffetType.create!(
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
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Editar'

    fill_in 'Nome', with: 'Aniversário'
    fill_in 'Descrição', with: 'Aniversário sem bebida'
    fill_in 'Quantidade máxima de pessoas', with: '60'
    fill_in 'Quantidade mínima de pessoas', with: '6'
    fill_in 'Duração', with: '180'
    fill_in 'Cardápio', with: 'Comida doce'
    select 'Indisponível', from: 'Bebidas alcoólicas'
    select 'Disponível', from: 'Decoração'
    select 'Disponível', from: 'Serviço de estacionamento'
    select 'Indisponível', from: 'Endereço exclusivo'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Seu tipo de Buffet foi editado com sucesso!'
    expect(page).to have_content 'Nome: Aniversário'
    expect(page).to have_content 'Descrição: Aniversário sem bebida'
    expect(page).to have_content('Quantidade máxima de pessoas: 60 pessoas')
    expect(page).to have_content('Quantidade mínima de pessoas: 6 pessoa')
    expect(page).to have_content('Duração: 180 minutos')
    expect(page).to have_content('Cardápio: Comida doce')
    expect(page).to have_content('Bebidas alcoólicas: Indisponível')
    expect(page).to have_content('Decoração: Disponível')
    expect(page).to have_content('Decoração: Disponível')
    expect(page).to have_content('Serviço de estacionamento: Disponível')
    expect(page).to have_content('Endereço exclusivo: Indisponível')
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
    BuffetType.create!(
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
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Editar'

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Quantidade máxima de pessoas', with: ''
    fill_in 'Quantidade mínima de pessoas', with: ''
    fill_in 'Duração', with: ''
    fill_in 'Cardápio', with: ''
    select 'Indisponível', from: 'Bebidas alcoólicas'
    select 'Indisponível', from: 'Decoração'
    select 'Indisponível', from: 'Serviço de estacionamento'
    select 'Indisponível', from: 'Endereço exclusivo'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível atualizar o seu tipo de Buffet'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content('Quantidade máxima de pessoas não pode ficar em branco')
    expect(page).to have_content('Quantidade mínima de pessoas não pode ficar em branco')
    expect(page).to have_content('Duração não pode ficar em branco')
    expect(page).to have_content('Cardápio não pode ficar em branco')
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
    visit edit_buffet_type_path(joao_buffet_type)

    # Expect
    expect(current_path).not_to eq edit_buffet_type_path(joao_buffet_type)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este tipo de Buffet.'
  end

  it 'e volta para tipo de buffet' do
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
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Editar'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq buffet_type_path(buffet_type)
    expect(page).to have_content 'Nome: Casamento'
  end

  it 'e se for não autentificado, pede login' do
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
    visit edit_buffet_type_path(buffet_type)

    # Expect
    expect(current_path).not_to eq edit_buffet_type_path(buffet_type)
    expect(current_path).to eq new_buffet_owner_user_session_path
    expect(page).to have_content 'Você precisa ser usuário dono de buffet.'
  end

  it 'e se for Cliente, volta para home' do
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

    # Act
    login_as client, :scope => :client
    visit edit_buffet_type_path(buffet_type)

    # Expect
    expect(current_path).not_to eq edit_buffet_type_path(buffet_type)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Clientes apenas podem visualizar buffet.'
  end
end
