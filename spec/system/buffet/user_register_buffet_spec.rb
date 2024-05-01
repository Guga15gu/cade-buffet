require 'rails_helper'

describe 'Usuário Dono de Buffet cadastra um buffet' do
  it 'e não pode ser usuário não autentificado' do
    # Arrange
    #
    # Act
    visit new_buffet_path
    # Assert
    expect(current_path).to eq new_buffet_owner_user_session_path
  end

  it 'e não pode ser usuário Cliente' do
    # Arrange
    client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
    # Act
    login_as client, :scope => :client
    visit new_buffet_path
    # Assert
    expect(current_path).to eq new_buffet_owner_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Registrar Buffet'

    fill_in 'Nome Fantasia', with: 'Buffet Delícias'
    fill_in 'Razão Social', with: 'Empresa de Buffet Ltda'
    fill_in 'CNPJ', with: '12345678901234'
    fill_in 'Telefone para Contato', with: '(11) 1234-5678'
    fill_in 'Endereço', with: 'Rua dos Sabores, 123'
    fill_in 'Bairro', with: 'Centro'
    fill_in 'Estado', with: 'São Paulo'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'CEP', with: '12345-678'
    fill_in 'Descrição', with: 'Buffet especializado em eventos corporativos'
    fill_in 'Meios de Pagamento', with: 'Cartão de crédito, Dinheiro'

    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Seu Buffet foi cadastrado com sucesso!'
    expect(page).to have_content('Buffet Delícias')
    expect(page).to have_content('Razão Social: Empresa de Buffet Ltda')
    expect(page).to have_content('CNPJ: 12345678901234')
    expect(page).to have_content('Contato: (11) 1234-5678')
    expect(page).to have_content('Endereço: Rua dos Sabores, 123')
    expect(page).to have_content('Bairro: Centro')
    expect(page).to have_content('Estado: São Paulo')
    expect(page).to have_content('Cidade: São Paulo')
    expect(page).to have_content('CEP: 12345-678')
    expect(page).to have_content('Descrição: Buffet especializado em eventos corporativos')
    expect(page).to have_content('Meios de Pagamento: Cartão de crédito, Dinheiro')
  end

  it 'e pode somente cadastrar um Buffet' do
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
    expect(page).not_to have_link 'Registrar Buffet'
  end

  it 'e não consegue cadastrar um segundo Buffet' do
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
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit new_buffet_path

    # Assert
    expect(current_path).not_to eq new_buffet_path
    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content 'Você já é dono de um Buffet, e apenas podes ser Dono de um Buffet!'
  end

  it 'e não informa Nome Fantasia' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as(buffet_owner_user, :scope => :buffet_owner_user)
    visit root_path
    click_on 'Registrar Buffet'

    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: 'Empresa de Buffet Ltda'
    fill_in 'CNPJ', with: '12345678901234'
    fill_in 'Telefone para Contato', with: '(11) 1234-5678'
    fill_in 'Endereço', with: 'Rua dos Sabores, 123'
    fill_in 'Bairro', with: 'Centro'
    fill_in 'Estado', with: 'São Paulo'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'CEP', with: '12345-678'
    fill_in 'Descrição', with: 'Buffet especializado em eventos corporativos'
    fill_in 'Meios de Pagamento', with: 'Cartão de crédito, Dinheiro'

    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Seu Buffet não foi cadastrado.'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
  end
end
