FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "#{Faker::Internet.username}#{n}" }
    sequence(:email) { |n| "#{Faker::Internet.username}#{n}@example.com" }
    password { "password" }
  end
end
