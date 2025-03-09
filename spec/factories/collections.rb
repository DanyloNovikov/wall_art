# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    publish { [true, false].sample }
  end
end
