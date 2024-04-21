require 'rails_helper'

describe 'Usuário edita um preço de tipo de buffet' do
  it 'a partir da tela inicial' do
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

    buffet_type = BuffetType.create!(
      name: 'Casamento',
      description: 'Casamento com comida',
      max_capacity_people: 10,
      min_capacity_people: 5,
      duration: 120,
      menu: 'Comida caseira e doce',
      alcoholic_beverages: true,
      decoration: true,
      parking_valet: true,
      exclusive_address: true,
      buffet: buffet
    )

    buffet_type_price = BuffetTypePrice.create!(
      base_price_weekday: 10,
      additional_per_person_weekday: 10,
      additional_per_hour_weekday: 20,
      base_price_weekend: 20,
      additional_per_person_weekend: 20,
      additional_per_hour_weekend: 40,
      buffet_type: buffet_type
    )

    # Act
    login_as(buffet_owner_user)
    visit root_path
    click_on 'Casamento'
    click_on 'Editar preço'

    # Expect
    expect(page).to have_content 'Editar preço de tipo de Buffet'
    expect(page).to have_field 'Preço base em dia de semana', with: '10'
    expect(page).to have_field 'Adicional por pessoa em dia de semana', with: '10'
    expect(page).to have_field 'Adicional por hora em dia de semana', with: '20'
    expect(page).to have_field 'Preço base em fim de semana', with: '20'
    expect(page).to have_field 'Adicional por pessoa em fim de semana', with: '20'
    expect(page).to have_field 'Adicional por hora em fim de semana', with: '40'
    expect(page).to have_button 'Enviar'
  end

  
end
