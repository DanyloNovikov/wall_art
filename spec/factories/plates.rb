# frozen_string_literal: true

FactoryBot.define do
  factory :plate do
    title { Faker::Commerce.color }
    order { rand(1..10) }
    association :collection
  end
end
