# frozen_string_literal: true

FactoryBot.define do
  factory :publication do
    title { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
    files { FFaker::Internet.http_url }
    user
  end
end
