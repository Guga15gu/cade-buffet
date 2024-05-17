client = Client.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo', cpf:  '408.357.400-30')

another_client = Client.create!(email: 'joao@email.com', password: 'password', name: 'João', cpf:  '135.060.870-02')

buffet_owner_user_a = BuffetOwnerUser.create!(email: 'gustavo@email.com', password: 'password', name: 'Gustavo')
buffet_a = Buffet.create!(
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
  buffet_owner_user: buffet_owner_user_a
)
buffet_type_a = BuffetType.create!(
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
  buffet: buffet_a
)
BuffetTypePrice.create!(
  base_price_weekday: 10,
  additional_per_person_weekday: 11,
  additional_per_hour_weekday: 20,
  base_price_weekend: 21,
  additional_per_person_weekend: 30,
  additional_per_hour_weekend: 31,
  buffet_type: buffet_type_a
)
Order.create!(
  client: client,
  buffet: buffet_a,
  buffet_type: buffet_type_a,
  date: 7.day.from_now,
  number_of_guests: 6,
  address: 'Rua Joao, 50',
  event_details: 'Sem mais detalhes',
  has_custom_address: true
)
buffet_owner_user_b = BuffetOwnerUser.create!(email: 'joao@email.com', password: 'password', name: 'Joao')
buffet_b = Buffet.create!(
  business_name: 'Buffet Maravilhoso',
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
  buffet_owner_user: buffet_owner_user_b
)
buffet_type_b = BuffetType.create!(
  name: 'Festa',
  description: 'Festa com comida',
  max_capacity_people: 10,
  min_capacity_people: 5,
  duration: 120,
  menu: 'Comida caseira e doce',
  alcoholic_beverages: true,
  decoration: true,
  parking_valet: true,
  exclusive_address: true,
  buffet: buffet_b
)
BuffetTypePrice.create!(
  base_price_weekday: 10,
  additional_per_person_weekday: 11,
  additional_per_hour_weekday: 20,
  base_price_weekend: 21,
  additional_per_person_weekend: 30,
  additional_per_hour_weekend: 31,
  buffet_type: buffet_type_b
)
Order.create!(
  client: client,
  buffet: buffet_b,
  buffet_type: buffet_type_b,
  date: 8.day.from_now,
  number_of_guests: 6,
  address: 'Rua Joao, 50',
  event_details: 'Sem mais detalhes',
  has_custom_address: true
)

buffet_owner_user_c = BuffetOwnerUser.create!(email: 'alex@email.com', password: 'password', name: 'alex')
buffet_c = Buffet.create!(
  business_name: 'Buffet Celestial',
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
  buffet_owner_user: buffet_owner_user_c
)
buffet_type_c = BuffetType.create!(
  name: 'Restaurante',
  description: 'Restaurante com comida',
  max_capacity_people: 10,
  min_capacity_people: 5,
  duration: 120,
  menu: 'Comida caseira e doce',
  alcoholic_beverages: true,
  decoration: true,
  parking_valet: true,
  exclusive_address: true,
  buffet: buffet_c
)
BuffetTypePrice.create!(
  base_price_weekday: 10,
  additional_per_person_weekday: 11,
  additional_per_hour_weekday: 20,
  base_price_weekend: 21,
  additional_per_person_weekend: 30,
  additional_per_hour_weekend: 31,
  buffet_type: buffet_type_c
)
Order.create!(
  client: another_client,
  buffet: buffet_c,
  buffet_type: buffet_type_c,
  date: 3.day.from_now,
  number_of_guests: 6,
  address: 'Rua Joao, 50',
  event_details: 'Sem mais detalhes',
  has_custom_address: true
)
