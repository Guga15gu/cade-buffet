require 'rails_helper'

describe 'Usuário cadastra um tipo de buffet' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(current_path).not_to have_link 'Cadastrar Tipo de Evento'
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

    # Act
    login_as(buffet_owner_user)
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
    expect(page).to have_content('Decoração: Disponível')
    expect(page).to have_content('Serviço de estacionamento: Disponível')
    expect(page).to have_content('Endereço exclusivo: Indisponível')

  end
end
