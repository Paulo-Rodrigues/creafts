class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true

  enum :status, { inactive: 0, active: 1 }, default: :active
end
