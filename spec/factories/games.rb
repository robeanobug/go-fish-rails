FactoryBot.define do
  factory :game do
    name { "MyGame" }
    player_count { 2 }
    bot_count { 0 }
    users { [] }
  end
end
