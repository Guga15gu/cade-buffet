require 'rails_helper'

describe 'Usuário edita um tipo de  buffet' do
  it 'e deve estar autenticado' do
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

    # Act
    patch(buffet_type_path(buffet_type), params: { buffet_type: {duration: '50'}})

    # Assert
    expect(response).not_to redirect_to(buffet_type_path(buffet_type))
    expect(response).to redirect_to(new_buffet_owner_user_session_path)
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

     gustavo_buffet = Buffet.create!(
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

     joao_buffet_type = BuffetType.create!(
       name: 'Casamento',
       description: 'Casamento com comida',
       max_capacity_people: 10,
       min_capacity_people: 5,
       duration: 120,
       menu: 'Comida caseira e doce',
       alcoholic_beverages: false,
       decoration: true,
       parking_valet: true,
       exclusive_address: true,
       buffet: joao_buffet
     )

     gustavo_buffet_type = BuffetType.create!(
       name: 'Casamento Líquido',
       description: 'Casamento com bebida',
       max_capacity_people: 100,
       min_capacity_people: 50,
       duration: 240,
       menu: 'Sopa',
       alcoholic_beverages: true,
       decoration: true,
       parking_valet: true,
       exclusive_address: true,
       buffet: gustavo_buffet
     )

     # Act
     login_as(gustavo)
     patch(buffet_type_path(joao_buffet_type), params: { buffet_type: {name: 'HEhehHE'}})

     # Expect
     expect(response).not_to redirect_to buffet_type_path(joao_buffet_type)
     expect(response).to redirect_to(root_path)
  end
end
