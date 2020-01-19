class Product < ApplicationRecord
  monetize :price_cents

  validates :name, presence: true
end
