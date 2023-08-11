# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    password { FFaker::Internet.password }
    profile_photo { FFaker::Image.url }
  end
end
