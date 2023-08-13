# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    password { FFaker::Internet.password }

    transient do
      jwt_token { nil }
    end

    after(:build) do |user, evaluator|
      user.define_singleton_method(:jwt_token) { evaluator.jwt_token }
    end
  end
end
