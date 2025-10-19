FactoryBot.define do
  factory :product do
    name { "Book 1" }
    description { "Data Science book" }
    category { create(:category) }
    status { 1 }
  end
end
