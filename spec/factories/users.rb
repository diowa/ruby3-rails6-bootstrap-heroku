# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    after :build do |user|
      user.avatar.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/user-circle.svg')),
        filename: 'user-circle.svg',
        content_type: 'image/svg+xml',
        identify: false
      )
    end
  end
end
