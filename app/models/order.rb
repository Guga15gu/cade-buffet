class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :buffet_type
  belongs_to :client

  enum status: { pending: 0, confirmed_by_client:5, canceled: 9, approved_by_buffet_owner: 14 }
  
  before_validation :generate_code, on: :create

  validates :buffet_id, :buffet_type_id, :date, :number_of_guests, :event_details, :code, :status, :client_id, presence: true

  validate :outside_capacity_of_people?, :has_address?

  def calculate_price
    buffet_type_price = buffet_type.buffet_type_price

    extra_people = number_of_guests - buffet_type.min_capacity_people
    if date.on_weekday?
      min_value = buffet_type_price.base_price_weekday
      additional_per_person = buffet_type_price.additional_per_person_weekday
    else
      min_value = buffet_type_price.base_price_weekend
      additional_per_person = buffet_type_price.additional_per_person_weekend
    end

    min_value + extra_people * additional_per_person
  end

  def calculate_price_with_tax_or_discount
    calculate_price + tax_or_discount
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def outside_capacity_of_people?
    buffet_type = BuffetType.find(self.buffet_type_id)
    if self.number_of_guests.present? and self.number_of_guests > buffet_type.max_capacity_people
      self.errors.add(:number_of_guests, " está fora do mínimo de #{buffet_type.min_capacity_people} e máximo de #{buffet_type.max_capacity_people} pessoas")
    end
  end

  def has_address?
    if self.has_custom_address and self.address == ''
      self.errors.add(:address, " não pode ficar em branco")
    end
  end
end
