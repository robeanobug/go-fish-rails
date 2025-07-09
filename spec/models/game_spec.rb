require 'rails_helper'

RSpec.describe Game, type: :model do
  xit 'inflates a GoFish game from JSON' do
    user1 = create(:user)
    user2 = create(:user)
    go_fish_json = {
      'players' => [{
        'user_id' => user1.id,
        'cards' => [{ 'suit' => 'Clubs', 'rank' => 'Four'}]
      }, {
        'user_id' => user2.id,
        'cards' => [{ 'suit' => 'Hearts', 'rank' => 'Jack'}]
      }],
      'deck' => {
        'cards' => [{ 'suit' => 'Diamonds', 'rank' => 'Ace' }]
      }
    }
    game = create(:game, go_fish: go_fish_json)

    expect(game.go_fish.players.map(&:user)).to match_array [ user1, user2 ]
    expect(game.go_fish.players.first.cards.first).to eq Card.new(suit: 'Clubs', rank: 'Four')
    expect(game.go_fish.deck.cards.first).to eq Card.new(suit: 'Diamonds', rank: 'Ace')
  end
end
