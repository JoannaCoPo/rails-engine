FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    unit_price { rand(100..5000) }
    description { Faker::Lorem.sentence }
  end
end
