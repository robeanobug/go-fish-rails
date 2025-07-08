FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{Faker::Internet.username}#{n}@example.com" }
    password { "password" }
  end
end