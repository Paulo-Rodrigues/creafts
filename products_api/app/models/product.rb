class Product < ApplicationRecord
  belongs_to :category
  has_many :price, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true

  enum :status, { unavailable: 0, available: 1 }, default: :available
end
