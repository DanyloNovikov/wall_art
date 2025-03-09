# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
