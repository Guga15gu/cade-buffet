require 'rails_helper'

describe 'Usuário cadastra um buffet' do
  it 'e deve estar autenticado' do
    # Arrange
    #
    # Act
    visit root_path
    click_on 'Registrar Buffet'
    # Assert
    expect(current_path).to eq new_buffet_owner_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    buffet_owner_user = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    login_as(buffet_owner_user)
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
    expect(page).to have_content('CPF: 12345678901234')
    expect(page).to have_content('Contato: (11) 1234-5678')
    expect(page).to have_content('Endereço: Rua dos Sabores, 123')
    expect(page).to have_content('Bairro: Centro')
    expect(page).to have_content('Estado: São Paulo')
    expect(page).to have_content('Cidade: São Paulo')
    expect(page).to have_content('CPF: 12345-678')
    expect(page).to have_content('Descrição: Buffet especializado em eventos corporativos')
    expect(page).to have_content('Meio de Pagamento: Cartão de crédito, Dinheiro')
  end

end
