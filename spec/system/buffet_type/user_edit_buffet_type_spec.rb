require 'rails_helper'

describe 'Usuário edita um tipo de buffet' do
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

end
