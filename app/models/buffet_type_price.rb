class BuffetTypePrice < ApplicationRecord
  belongs_to :buffet_type
  validates :base_price_weekday, :additional_per_person_weekday, :additional_per_hour_weekday, :base_price_weekend, :additional_per_person_weekend, :additional_per_hour_weekend, presence: true
end
