require 'rails_helper'

describe 'Usuário Cliente se autentica' do
  it 'com sucesso' do
    # Arrange
    Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf: 61445385007)

    # Act
    visit root_path
    within('nav') do
      click_on 'Entrar como cliente'
    end

    within('div form') do
      fill_in 'E-mail', with: 'gustavo@email.com'
      fill_in 'Senha', with: 'password'

      click_on 'Entrar'
    end

    # Assert
    within('nav') do
      expect(page).not_to have_link 'Entrar como cliente'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Cliente: Gustavo'
      expect(page).to have_content 'gustavo@email.com'
    end
    expect(page).to have_content 'Login efetuado com sucesso.'
  end

  it 'e faz logout' do
    # Arrange
    Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf: 61445385007)

    # Act
    visit root_path
    within('nav') do
      click_on 'Entrar como cliente'
    end
    within('div form') do
      fill_in 'E-mail', with: 'gustavo@email.com'
      fill_in 'Senha', with: 'password'

      click_on 'Entrar'
    end
    click_on 'Sair'

    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar como cliente'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'gustavo@email.com'
  end

  it 'e retorna' do
    # Act
    visit root_path
    within('nav') do
      click_on 'Entrar como cliente'
    end
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq root_path
  end
end
