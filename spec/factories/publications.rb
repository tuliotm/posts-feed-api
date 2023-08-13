# frozen_string_literal: true

FactoryBot.define do
  factory :publication do
    title { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
    file { FFaker::Internet.http_url }
    user
  end
end
