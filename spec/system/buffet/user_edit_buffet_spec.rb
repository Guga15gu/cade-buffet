require 'rails_helper'

describe 'Usuário edita um buffet' do
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
end
