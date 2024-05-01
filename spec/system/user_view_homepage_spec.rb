require 'rails_helper'

describe 'Usuário não autentificado visita tela inicial' do
  it 'e vê o nome da app' do
    # Arrange

    # Act
    visit('/')
    # Assert
    expect(page).to have_content('Cadê Buffet?')
  end

  it 'e vê lista de buffets' do
    # Arrange
    gustavo = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    joao = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'João')

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
      buffet_owner_user: joao
    )
    Buffet.create!(
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
    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Registrar Buffet'
    expect(page).to have_content('Buffet Delícias, São Paulo - São Paulo')
    expect(page).to have_content('Buffet Redondo, Pelotas - Rio Grande do Sul')
  end

  it 'e não existem buffets cadastrados' do
    # Arrange

    # Act
    visit(root_path)

    # Assert
    expect(page).not_to have_link 'Registrar Buffet'
    expect(page).to have_content('Não existem buffets cadastrados')

  end
end

describe 'Usuário Dono de Buffet visita tela inicial' do
  it 'e vê seu buffet' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    Buffet.create!(
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
      buffet_owner_user: buffet_owner_user
    )

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path

    # Assert
    expect(page).to have_content 'Buffet Redondo'
    expect(page).not_to have_link 'Registrar Buffet'
  end

  it 'e vê botão Registrar Buffet' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit root_path

    # Assert
    expect(page).to have_link 'Registrar Buffet'
  end

  it 'e não vê outros buffets' do
    # Arrange
    gustavo = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    joao = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'João')
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
      buffet_owner_user: joao
    )

    # Act
    login_as gustavo, :scope => :buffet_owner_user
    visit root_path

    # Assert
    expect(page).not_to have_content 'Buffet Delícias'
    expect(page).to have_link 'Registrar Buffet'
  end
end

describe 'Usuário Cliente visita tela inicial' do
  it 'e vê lista de buffets' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    gustavo = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    joao = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'João')

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
      buffet_owner_user: joao
    )
    Buffet.create!(
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
    # Act
    login_as client, :scope => :client
    visit root_path

    # Assert
    expect(page).not_to have_link 'Registrar Buffet'
    expect(page).to have_content('Buffet Delícias, São Paulo - São Paulo')
    expect(page).to have_content('Buffet Redondo, Pelotas - Rio Grande do Sul')
  end

  it 'e não existem buffets cadastrados' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    # Act
    login_as client, :scope => :client
    visit(root_path)

    # Assert
    expect(page).not_to have_link 'Registrar Buffet'
    expect(page).to have_content('Não existem buffets cadastrados')

  end
end
