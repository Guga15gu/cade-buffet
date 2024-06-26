require 'rails_helper'

describe 'Usuário Dono de Buffet edita um buffet' do
  it 'a partir da tela inicial' do
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
    click_on 'Buffet Delícias'
    click_on 'Editar Buffet'

    # Assert
    expect(page).to have_content 'Editar Buffet'
    expect(page).to have_field 'Nome Fantasia', with: 'Buffet Delícias'
    expect(page).to have_field 'Razão Social', with: 'Empresa de Buffet Ltda'
    expect(page).to have_field 'CNPJ', with: '12345678901234'
    expect(page).to have_field 'Telefone para Contato', with: '(11) 1234-5678'
    expect(page).to have_field 'Endereço', with: 'Rua dos Sabores, 123'
    expect(page).to have_field 'Bairro', with: 'Centro'
    expect(page).to have_field 'Estado', with: 'São Paulo'
    expect(page).to have_field 'Cidade', with: 'São Paulo'
    expect(page).to have_field 'CEP', with: '12345-678'
    expect(page).to have_field 'Descrição', with: 'Buffet especializado em eventos corporativos'
    expect(page).to have_field 'Meios de Pagamento', with: 'Cartão de crédito, Dinheiro'
    expect(page).to have_button 'Enviar'
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
    click_on 'Buffet Delícias'
    click_on 'Editar Buffet'

    fill_in 'Nome Fantasia', with: 'Buffet Delicioso'
    fill_in 'Razão Social', with: 'Empresa de Buffet Amigos Ltda'
    fill_in 'CNPJ', with: '5678901234'
    fill_in 'Telefone para Contato', with: '(11) 3210-5678'
    fill_in 'Endereço', with: 'Rua dos Desejos, 456'
    fill_in 'Bairro', with: 'Caju'
    fill_in 'Estado', with: 'Rio de Janeiro'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'CEP', with: '6753-678'
    fill_in 'Descrição', with: 'Buffet especializado em casamentos'
    fill_in 'Meios de Pagamento', with: 'Cheque, Cartão de crédito, Dinheiro'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Seu Buffet foi editado com sucesso!'
    expect(page).to have_content('Buffet Delicioso')
    expect(page).to have_content('Razão Social: Empresa de Buffet Amigos Ltda')
    expect(page).to have_content('CNPJ: 5678901234')
    expect(page).to have_content('Contato: (11) 3210-5678')
    expect(page).to have_content('Endereço: Rua dos Desejos, 456')
    expect(page).to have_content('Bairro: Caju')
    expect(page).to have_content('Estado: Rio de Janeiro')
    expect(page).to have_content('Cidade: Rio de Janeiro')
    expect(page).to have_content('CEP: 6753-678')
    expect(page).to have_content('Descrição: Buffet especializado em casamentos')
    expect(page).to have_content('Meios de Pagamento: Cheque, Cartão de crédito, Dinheiro')
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
    click_on 'Buffet Delícias'
    click_on 'Editar Buffet'

    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Telefone para Contato', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Estado', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'CEP', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Meios de Pagamento', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível atualizar o Buffet'
    expect(page).to have_content "Nome Fantasia não pode ficar em branco"
    expect(page).to have_content "Razão Social não pode ficar em branco"
    expect(page).to have_content "CNPJ não pode ficar em branco"
    expect(page).to have_content "Telefone para Contato não pode ficar em branco"
    expect(page).to have_content "Endereço não pode ficar em branco"
    expect(page).to have_content "Bairro não pode ficar em branco"
    expect(page).to have_content "Estado não pode ficar em branco"
    expect(page).to have_content "Cidade não pode ficar em branco"
    expect(page).to have_content "CEP não pode ficar em branco"
    expect(page).to have_content "Descrição não pode ficar em branco"
    expect(page).to have_content "Meios de Pagamento não pode ficar em branco"
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
    login_as(gustavo, :scope => :buffet_owner_user)
    visit edit_buffet_path(joao_buffet)

    # Expect
    expect(current_path).not_to eq edit_buffet_path(joao_buffet)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este buffet.'

  end

  it 'e volta para buffet' do
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
    visit root_path
    click_on 'Buffet Delícias'
    click_on 'Editar Buffet'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content 'Nome Fantasia: Buffet Delícias'
  end

  it 'se não for usuário não autentificado' do
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
    visit edit_buffet_path(buffet)

    # Assert
    expect(current_path).not_to eq edit_buffet_path(buffet)
    expect(current_path).to eq new_buffet_owner_user_session_path
    expect(page).to have_content 'Você precisa ser usuário dono de buffet.'
  end

  it 'se não for usuário Cliente' do
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
    # Act
    login_as client, :scope => :client
    visit edit_buffet_path(buffet)

    # Assert
    expect(current_path).not_to eq edit_buffet_path(buffet)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Clientes apenas podem visualizar buffet.'
  end
end
