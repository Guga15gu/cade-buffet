class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, cpf: { message: 'CPF é inválido' }

end
