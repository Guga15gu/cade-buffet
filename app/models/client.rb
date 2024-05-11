class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, cpf: { message: 'é inválido' }

end
