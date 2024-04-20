class BuffetType < ApplicationRecord
  belongs_to :buffet
  validates :name, :description, :max_capacity_people, :min_capacity_people, :duration, :menu, presence: true

end
