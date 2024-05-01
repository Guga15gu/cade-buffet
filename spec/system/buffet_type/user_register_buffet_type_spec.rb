require 'rails_helper'

describe 'Usuário Dono de Buffet cadastra um tipo de buffet' do
  it 'e não pode ser não autentificado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(current_path).not_to have_link 'Cadastrar Tipo de Evento'
  end

  it 'e não pode ser Cliente' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    # Act
    login_as client, :scope => :client
    visit root_path

    # Assert
    expect(current_path).not_to have_link 'Cadastrar Tipo de Evento'
  end

  it 'e Cliente não acessa formulário' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as client, :scope => :client
    visit new_buffet_type_path

    # Assert
    expect(current_path).not_to eq new_buffet_type_path
    expect(current_path).to eq root_path
    expect(page).to have_content 'Clientes apenas podem visualizar buffet.'
  end

  it 'e não autentificado não acessa formulário' do
    # Arrange

    # Act
    visit new_buffet_type_path

    # Assert
    expect(current_path).not_to eq new_buffet_type_path
    expect(current_path).to eq buffet_owner_user_session_path
    expect(page).to have_content 'Você precisa ser usuário dono de buffet.'
  end

  it 'e só acha link para cadastro se existe um buffet' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path

    # Assert
    expect(page).not_to have_link 'Registrar Tipo de Evento'
  end

  it 'com sucesso' do
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

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Registrar Tipo de Evento'

    fill_in 'Nome', with: 'Casamento'
    fill_in 'Descrição', with: 'Casamento com comida'
    fill_in 'Quantidade máxima de pessoas', with: '100'
    fill_in 'Quantidade mínima de pessoas', with: '1'
    fill_in 'Duração', with: '120'
    fill_in 'Cardápio', with: 'Comida caseira e doce'
    select 'Disponível', from: 'Bebidas alcoólicas'
    select 'Disponível', from: 'Decoração'
    select 'Disponível', from: 'Serviço de estacionamento'
    select 'Indisponível', from: 'Endereço exclusivo'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Seu tipo de Buffet foi cadastrado com sucesso!'
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

  it 'e mantém os campos obrigatórios' do
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

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Registrar Tipo de Evento'

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
    expect(page).to have_content 'Seu Tipo de Buffet não foi cadastrado'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content('Quantidade máxima de pessoas não pode ficar em branco')
    expect(page).to have_content('Quantidade mínima de pessoas não pode ficar em branco')
    expect(page).to have_content('Duração não pode ficar em branco')
    expect(page).to have_content('Cardápio não pode ficar em branco')
  end

  it 'se somente já existe um buffet' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit new_buffet_type_path

    # Assert
    expect(current_path).not_to eq new_buffet_type_path
    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Como Dono de Buffet, precisas cadastrar seu buffet!'
  end

  it 'e volta para tela inicial' do
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

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Registrar Tipo de Evento'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq root_path
  end
end
