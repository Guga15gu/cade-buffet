require 'rails_helper'

describe 'Usuário Cliente cria conta' do
  it 'e vê página de cadastro' do
    # Act
    visit root_path
    click_on 'Entrar como cliente'
    click_on 'Criar uma conta'

    # Assert
    expect(current_path).to eq new_client_registration_path
    expect(page).to have_content 'Crie sua conta como cliente'
  end

  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar como cliente'
    click_on 'Criar uma conta'
    fill_in 'Nome', with: 'Maria'
    fill_in 'E-mail', with: 'maria@email.com'
    fill_in 'CPF', with: '61445385007'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert
    within("nav") do
      expect(page).to have_content 'Cliente: Maria'
      expect(page).to have_content 'maria@email.com'
      expect(page).not_to have_link 'Entrar como cliente'
      expect(page).not_to have_link 'Entrar como dono de buffet'
      expect(page).to have_button 'Sair'
    end
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    user = Client.last
    expect(user.name).to eq 'Maria'
  end
end
