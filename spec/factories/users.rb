# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'User' }

    trait :active do
      active { true }
    end
  end
end
