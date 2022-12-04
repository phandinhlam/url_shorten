FactoryBot.define do
  factory :link do
    url { Faker::Internet.url }
    short_url { Faker::Alphanumeric.alpha(number: 10) }
  end
end
