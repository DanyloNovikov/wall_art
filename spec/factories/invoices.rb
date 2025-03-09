# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    collection
    plate
  end
end
