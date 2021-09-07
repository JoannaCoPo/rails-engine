# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    name { Faker::Name.name }

    factory :merchant_plus_items do
      transient do
        items_count { 5 }
      end

      after(:create) do |merchant, evaluator|
        create_list(:item, evaluator.items_count, merchant: merchant)
      end
      # merchant.reload
    end
  end
end
