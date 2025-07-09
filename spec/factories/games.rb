FactoryBot.define do
  factory :game do
    name { "MyGame" }
    player_count { 2 }
    users { [] }
  end
end
