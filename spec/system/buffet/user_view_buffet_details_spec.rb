require 'rails_helper'

describe 'Usuário Dono de Buffet vê Buffet' do
  it 'a apartir da tela inicial' do
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
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit(root_path)
    click_on 'Buffet Delícias'

    # Assert
    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content "Nome Fantasia"
    expect(page).to have_content "Razão Social"
    expect(page).to have_content "CNPJ"
    expect(page).to have_content "Telefone para Contato"
    expect(page).to have_content "Endereço"
    expect(page).to have_content "Bairro"
    expect(page).to have_content "Estado"
    expect(page).to have_content "Cidade"
    expect(page).to have_content "CEP"
    expect(page).to have_content "Descrição"
    expect(page).to have_content "Meios de Pagamento"
  end

  it 'e vê botão de editar' do
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
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit(root_path)
    click_on 'Buffet Delícias'

    # Expect
    expect(page).to have_link 'Editar'
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
    login_as buffet_owner_user, :scope => :buffet_owner_user
    visit(root_path)
    click_on 'Buffet Delícias'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq root_path
  end

  it 'e não vê buffet de outro' do
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
    login_as gustavo, :scope => :buffet_owner_user
    visit buffet_path(joao_buffet)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não é dono desse buffet'
  end
end

describe 'Usuário não autentificado vê Buffet' do
  it 'a apartir da tela inicial' do
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
    visit(root_path)
    click_on 'Buffet Delícias'

    # Assert
    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content "Nome Fantasia: Buffet Delícias"
    expect(page).not_to have_content "Razão Social: Empresa de Buffet Ltda"
    expect(page).to have_content "CNPJ: 12345678901234"
    expect(page).to have_content "Telefone para Contato: (11) 1234-5678"
    expect(page).to have_content "Endereço: Rua dos Sabores, 123"
    expect(page).to have_content "Bairro: Centro"
    expect(page).to have_content "Estado: São Paulo"
    expect(page).to have_content "Cidade: São Paulo"
    expect(page).to have_content "CEP: 12345-678"
    expect(page).to have_content "Descrição: Buffet especializado em eventos corporativos"
    expect(page).to have_content "Meios de Pagamento: Cartão de crédito, Dinheiro"
  end

  it 'e não vê botão de editar' do
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
    visit(root_path)
    click_on 'Buffet Delícias'

    # Expect
    expect(page).not_to have_link 'Editar'
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
    visit(root_path)
    click_on 'Buffet Delícias'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq root_path
  end
end

describe 'Usuário Cliente vê Buffet' do
  it 'a apartir da tela inicial' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

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
    login_as client, :scope => :client
    visit(root_path)
    click_on 'Buffet Delícias'

    # Assert
    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content "Nome Fantasia: Buffet Delícias"
    expect(page).not_to have_content "Razão Social: Empresa de Buffet Ltda"
    expect(page).to have_content "CNPJ: 12345678901234"
    expect(page).to have_content "Telefone para Contato: (11) 1234-5678"
    expect(page).to have_content "Endereço: Rua dos Sabores, 123"
    expect(page).to have_content "Bairro: Centro"
    expect(page).to have_content "Estado: São Paulo"
    expect(page).to have_content "Cidade: São Paulo"
    expect(page).to have_content "CEP: 12345-678"
    expect(page).to have_content "Descrição: Buffet especializado em eventos corporativos"
    expect(page).to have_content "Meios de Pagamento: Cartão de crédito, Dinheiro"
  end

  it 'e não vê botão de editar' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

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
    login_as client, :scope => :client
    visit(root_path)
    click_on 'Buffet Delícias'

    # Expect
    expect(page).not_to have_link 'Editar'
  end

  it 'e volta para tela inicial' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

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
    login_as client, :scope => :client
    visit(root_path)
    click_on 'Buffet Delícias'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq root_path
  end
end
