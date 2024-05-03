require 'rails_helper'

describe 'Usuário dono de buffet vê lista de tipos de buffet' do
  it 'e está vazia' do
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

    # Assert
    expect(page).to have_content 'Não há nenhum tipo de Buffet cadastrado.'
    expect(page).not_to have_content 'Tipos de Buffet:'
  end

  it 'e vê seus tipos de buffet' do
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
    BuffetType.create!(
      name: 'Festa',
      description: 'Festa carnívora',
      max_capacity_people: 300,
      min_capacity_people: 100,
      duration: 810,
      menu: 'Carne',
      alcoholic_beverages: false,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: buffet
    )
    BuffetType.create!(
      name: 'Aniversário',
      description: 'Aniversário vegano',
      max_capacity_people: 10,
      min_capacity_people: 4,
      duration: 310,
      menu: 'Doces e vegetais',
      alcoholic_beverages: true,
      decoration: false,
      parking_valet: false,
      exclusive_address: false,
      buffet: buffet
    )


    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path

    # Assert
    expect(page).not_to have_content 'Não há nenhum tipo de Buffet cadastrado.'
    expect(page).to have_content 'Tipos de Buffet:'
    expect(page).to have_link 'Casamento'
    expect(page).to have_link 'Festa'
    expect(page).to have_link 'Aniversário'
  end

  it 'e não vê tipos de buffet dos outros' do
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
      buffet: joao_buffet
    )
    BuffetType.create!(
      name: 'Festa',
      description: 'Festa carnívora',
      max_capacity_people: 300,
      min_capacity_people: 100,
      duration: 810,
      menu: 'Carne',
      alcoholic_beverages: false,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: gustavo_buffet
    )
    BuffetType.create!(
      name: 'Aniversário',
      description: 'Aniversário vegano',
      max_capacity_people: 10,
      min_capacity_people: 4,
      duration: 310,
      menu: 'Doces e vegetais',
      alcoholic_beverages: true,
      decoration: false,
      parking_valet: false,
      exclusive_address: false,
      buffet: joao_buffet
    )
    BuffetType.create!(
      name: 'Roda a roda',
      description: 'Verde comida',
      max_capacity_people: 1000,
      min_capacity_people: 40,
      duration: 1110,
      menu: 'Água e torrada',
      alcoholic_beverages: true,
      decoration: false,
      parking_valet: true,
      exclusive_address: false,
      buffet: gustavo_buffet
    )


    # Act
    login_as gustavo, :scope => :buffet_owner_user
    visit root_path

    # Assert
    expect(page).not_to have_content 'Não há nenhum tipo de Buffet cadastrado.'
    expect(page).to have_content 'Tipos de Buffet:'
    expect(page).not_to have_link 'Casamento'
    expect(page).to have_link 'Festa'
    expect(page).not_to have_link 'Aniversário'
    expect(page).to have_link 'Roda a roda'
  end

end

describe 'Usuário não autentificado vê lista de tipos de buffet' do
  it 'e vê seus tipos de buffet' do
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
    BuffetType.create!(
      name: 'Festa',
      description: 'Festa carnívora',
      max_capacity_people: 300,
      min_capacity_people: 100,
      duration: 810,
      menu: 'Carne',
      alcoholic_beverages: false,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: buffet
    )
    BuffetType.create!(
      name: 'Aniversário',
      description: 'Aniversário vegano',
      max_capacity_people: 10,
      min_capacity_people: 4,
      duration: 310,
      menu: 'Doces e vegetais',
      alcoholic_beverages: true,
      decoration: false,
      parking_valet: false,
      exclusive_address: false,
      buffet: buffet
    )


    # Act
    visit root_path
    click_on 'Buffet Delícias'

    # Assert
    expect(page).not_to have_content 'Não há nenhum tipo de Buffet cadastrado.'
    expect(page).to have_content 'Tipos de Buffet:'
    expect(page).to have_link 'Casamento'
    expect(page).to have_link 'Festa'
    expect(page).to have_link 'Aniversário'
  end
end

describe 'Usuário Cliente vê lista de tipos de buffet' do
  it 'e vê seus tipos de buffet' do
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
    BuffetType.create!(
      name: 'Festa',
      description: 'Festa carnívora',
      max_capacity_people: 300,
      min_capacity_people: 100,
      duration: 810,
      menu: 'Carne',
      alcoholic_beverages: false,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: buffet
    )
    BuffetType.create!(
      name: 'Aniversário',
      description: 'Aniversário vegano',
      max_capacity_people: 10,
      min_capacity_people: 4,
      duration: 310,
      menu: 'Doces e vegetais',
      alcoholic_beverages: true,
      decoration: false,
      parking_valet: false,
      exclusive_address: false,
      buffet: buffet
    )

    # Act
    login_as client, :scope => :client
    visit root_path
    click_on 'Buffet Delícias'

    # Assert
    expect(page).not_to have_content 'Não há nenhum tipo de Buffet cadastrado.'
    expect(page).to have_content 'Tipos de Buffet:'
    expect(page).to have_link 'Casamento'
    expect(page).to have_link 'Festa'
    expect(page).to have_link 'Aniversário'
  end
end
