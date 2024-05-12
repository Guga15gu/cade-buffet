class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :buffet_type
  belongs_to :client

  enum status: { pending: 0, confirmed:5, canceled: 9 }
  before_validation :generate_code, on: :create

  validates :buffet_id, :buffet_type_id, :date, :number_of_guests, :event_details, :code, :status, :client_id, presence: true

  validate :outside_capacity_of_people?, :has_address?

  def calculate_base_price
    0
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
