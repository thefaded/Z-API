class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, :trackable, :recoverable

  enum role: { guest: 0, client: 1, employee: 2 }
  enum gender: { not_prefer: 0, male: 1, female: 2 }

  # Validations
  validates :phone, phone_number: true, uniqueness: true, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{last_name} #{first_name}"
  end
end
