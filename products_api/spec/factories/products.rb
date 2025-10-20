FactoryBot.define do
  factory :product do
    name { "Book 1" }
    description { "Data Science book" }
    category { create(:category) }
    status { 1 }
    user_external_id { "XYZ123" }
  end
end
