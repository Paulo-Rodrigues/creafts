FactoryBot.define do
  factory :price do
    amount { 9.99 }
    product { create(:product) }
  end
end
