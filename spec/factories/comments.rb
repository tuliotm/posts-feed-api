# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    comment { FFaker::Lorem.sentence }
    association :user
    association :commentable, factory: :publication

    after(:build) do |publication|
      publication.file.attach(io: StringIO.new(""), filename: 'empty_file.txt', content_type: 'text/plain')
    end
  end
end
