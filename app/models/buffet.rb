class Buffet < ApplicationRecord
  belongs_to :buffet_owner_user
  has_many :buffet_types

  validates :business_name, :corporate_name, :registration_number, :contact_phone, :address, :district, :state, :city, :postal_code, :description, :payment_methods, :buffet_owner_user_id, presence: true
end
