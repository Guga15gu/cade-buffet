require 'rails_helper'

describe 'Usuário Dono de Buffet se autentica' do
  it 'com sucesso' do
    # Arrange
    BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    visit root_path
    within('nav') do
      click_on 'Entrar'
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
      expect(page).to have_content 'Gustavo'
      expect(page).to have_content 'gustavo@email.com'
    end
    expect(page).to have_content 'Login efetuado com sucesso.'
  end

  it 'e faz logout' do
    # Arrange
    BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')

    # Act
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    within('div form') do
      fill_in 'E-mail', with: 'gustavo@email.com'
      fill_in 'Senha', with: 'password'

      click_on 'Entrar'
    end
    click_on 'Sair'

    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'gustavo@email.com'
  end
end
