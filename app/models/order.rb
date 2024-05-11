class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :buffet_type
  belongs_to :client

  enum status: { pending: 0, confirmed:5, canceled: 9 }
  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end
end
