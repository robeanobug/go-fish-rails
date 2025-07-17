FactoryBot.define do
  factory :player do
    name { 'Player Name' }
    user_id { create(:user).id }
    hand { [] }
    books { [] }
  end
end
