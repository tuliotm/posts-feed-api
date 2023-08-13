# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    comment { FFaker::Lorem.sentence }
    association :user
    association :commentable, factory: :publication
  end
end
