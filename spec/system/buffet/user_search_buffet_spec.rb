require 'rails_helper'

describe 'Usuário não autentificado busca por um buffet' do
  it 'e vê botão de busca' do

    # Act
    visit root_path

    # Assert
    expect(page).to have_field('Buscar Buffet')
    expect(page).to have_button('Buscar')
  end

  it 'e encontra um buffet por nome' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet_owner_user_2 = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
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
    Buffet.create!(
      business_name: 'Buffet 2',
      corporate_name: '2',
      registration_number: '2',
      contact_phone: '2',
      address: 'Rua dos dois, 2',
      district: 'Centro 2',
      state: 'RJ',
      city: 'Rio de Janeiro',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos divinos',
      payment_methods: 'Dinheiro',
      buffet_owner_user: buffet_owner_user_2
    )
    # Act
    visit root_path
    fill_in 'Buscar Buffet', with: buffet.business_name
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: #{buffet.business_name}"
    expect(page).to have_content '1 buffet encontrado'
    expect(page).to have_content "Buffet Delícias, São Paulo - São Paulo"

  end

  it 'e encontra um buffet por cidade' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet_owner_user_2 = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
    buffet = Buffet.create!(
      business_name: 'Buffet Delícias',
      corporate_name: 'Empresa de Buffet Ltda',
      registration_number: '12345678901234',
      contact_phone: '(11) 1234-5678',
      address: 'Rua dos Sabores, 123',
      district: 'Centro',
      state: 'SP',
      city: 'São Paulo',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos corporativos',
      payment_methods: 'Cartão de crédito, Dinheiro',
      buffet_owner_user: buffet_owner_user
    )
    Buffet.create!(
      business_name: 'Buffet 2',
      corporate_name: '2',
      registration_number: '2',
      contact_phone: '2',
      address: 'Rua dos dois, 2',
      district: 'Centro 2',
      state: 'RJ',
      city: 'Rio de Janeiro',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos divinos',
      payment_methods: 'Dinheiro',
      buffet_owner_user: buffet_owner_user_2
    )
    # Act
    visit root_path
    fill_in 'Buscar Buffet', with: buffet.city
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: #{buffet.city}"
    expect(page).to have_content '1 buffet encontrado'
    expect(page).to have_content "Buffet Delícias, São Paulo - SP"

  end

  it 'e encontra um buffet por evento' do
    # Arrange
    buffet_owner_user_a = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet_owner_user_b = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
    buffet_a = Buffet.create!(
      business_name: 'Buffet Delícias',
      corporate_name: 'Empresa de Buffet Ltda',
      registration_number: '12345678901234',
      contact_phone: '(11) 1234-5678',
      address: 'Rua dos Sabores, 123',
      district: 'Centro',
      state: 'SP',
      city: 'São Paulo',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos corporativos',
      payment_methods: 'Cartão de crédito, Dinheiro',
      buffet_owner_user: buffet_owner_user_a
    )
    buffet_b = Buffet.create!(
      business_name: 'Buffet 2',
      corporate_name: '2',
      registration_number: '2',
      contact_phone: '2',
      address: 'Rua dos dois, 2',
      district: 'Centro 2',
      state: 'RJ',
      city: 'Rio de Janeiro',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos divinos',
      payment_methods: 'Dinheiro',
      buffet_owner_user: buffet_owner_user_b
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
    buffet_type_b = BuffetType.create!(
      name: 'Bar Líquido',
      description: 'Bar com bebida',
      max_capacity_people: 100,
      min_capacity_people: 50,
      duration: 240,
      menu: 'Sopa',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: buffet_b
    )
    # Act
    visit root_path
    fill_in 'Buscar Buffet', with: buffet_type_a.name
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: #{buffet_type_a.name}"
    expect(page).to have_content '1 buffet encontrado'
    expect(page).to have_content "Buffet Delícias, São Paulo - SP"

  end

  it 'e encontra vários buffets em ordem alfabética' do
    # Arrange
    buffet_owner_user_a = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    buffet_owner_user_b = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
    buffet_owner_user_c = BuffetOwnerUser.create!(email: 'maria@email.com', password: 'password', name: 'Maria')
    buffet_a = Buffet.create!(
      business_name: 'Espetacular',
      corporate_name: 'Empresa de Buffet Ltda',
      registration_number: '12345678901234',
      contact_phone: '(11) 1234-5678',
      address: 'Rua dos Sabores, 123',
      district: 'Centro',
      state: 'SP',
      city: 'São Paulo',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos corporativos',
      payment_methods: 'Cartão de crédito, Dinheiro',
      buffet_owner_user: buffet_owner_user_a
    )
    buffet_b = Buffet.create!(
      business_name: 'Divino',
      corporate_name: '2',
      registration_number: '2',
      contact_phone: '2',
      address: 'Rua dos dois, 2',
      district: 'Centro 2',
      state: 'RJ',
      city: 'Rio de Janeiro',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos divinos',
      payment_methods: 'Dinheiro',
      buffet_owner_user: buffet_owner_user_b
    )
    buffet_c = Buffet.create!(
      business_name: 'Amistoso',
      corporate_name: 'm2',
      registration_number: 'm2',
      contact_phone: 'm2',
      address: 'Rua dos M dois, m2',
      district: 'Arredor',
      state: 'RS',
      city: 'Pelotas',
      postal_code: '12345-678',
      description: 'Buffet especializado em eventos mágicos',
      payment_methods: 'Dinheiro, cheque',
      buffet_owner_user: buffet_owner_user_c
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
    buffet_type_b = BuffetType.create!(
      name: 'Bar Líquido',
      description: 'Bar com bebida',
      max_capacity_people: 100,
      min_capacity_people: 50,
      duration: 240,
      menu: 'Sopa',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: buffet_b
    )
    buffet_type_c = BuffetType.create!(
      name: 'Casamento Líquido',
      description: 'Casamento com bebida',
      max_capacity_people: 20,
      min_capacity_people: 3,
      duration: 60,
      menu: 'Líquidos doces',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: false,
      exclusive_address: false,
      buffet: buffet_c
    )
    # Act
    visit root_path
    fill_in 'Buscar Buffet', with: 'Casamento'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: Casamento"
    expect(page).to have_content '2 buffets encontrados'
    expect(page).to have_content "Amistoso, Pelotas - RS Espetacular, São Paulo - SP"
    expect(page).not_to have_content "Espetacular, São Paulo - SP Amistoso, Pelotas - RS"
    expect(page).not_to have_content "Divino, Rio de Janeiro - RJ"

  end
end

describe 'Usuário dono de buffet' do
  it 'não vê botão de busca' do
    # Arrange
    user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    # Act
    login_as user, :scope => :buffet_owner_user
    visit root_path

    # Assert
    expect(page).not_to have_field('Buscar Buffet')
    expect(page).not_to have_button('Buscar')
  end

end
