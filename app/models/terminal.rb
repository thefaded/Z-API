class Terminal < ApplicationRecord
  devise :database_authenticatable

  validates :name, presence: true
end
