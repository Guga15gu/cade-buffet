require 'rails_helper'

describe 'Usuário cliente se autentica' do
  it 'com sucesso' do
    # Arrange
    Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

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
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Cliente: Gustavo'
      expect(page).to have_content 'gustavo@email.com'
    end
    expect(page).to have_content 'Login efetuado com sucesso.'
  end
end
