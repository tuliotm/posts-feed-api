# spec/factories/publications.rb

FactoryBot.define do
  factory :publication do
    title { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
    user

    after(:build) do |publication|
      publication.file.attach(io: StringIO.new(""), filename: 'empty_file.txt', content_type: 'text/plain')
    end
  end
end
