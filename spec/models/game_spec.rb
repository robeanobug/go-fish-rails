require 'rails_helper'

RSpec.describe Game, type: :model do
  it 'inflates a GoFish game from JSON' do
    user1 = create(:user)
    user2 = create(:user)

    go_fish_json = {
      'players' => [ {
        'user_id' => user1.id,
        'name' => user1.username,
        'hand' => [ { 'suit' => 'Clubs', 'rank' => 'Four' } ],
        'books' => [ [
          { 'suit' => 'Clubs', 'rank' => 'Ace' },
          { 'suit' => 'Diamonds', 'rank' => 'Ace' },
          { 'suit' => 'Spades', 'rank' => 'Ace' },
          { 'suit' => 'Hearts', 'rank' => 'Ace' }
          ] ]
      }, {
        'user_id' => user2.id,
        'name' => user2.username,
        'hand' => [ { 'suit' => 'Hearts', 'rank' => 'Jack' } ],
        'books' => [ [
          { 'suit' => 'Clubs', 'rank' => 'King' },
          { 'suit' => 'Diamonds', 'rank' => 'King' },
          { 'suit' => 'Spades', 'rank' => 'King' },
          { 'suit' => 'Hearts', 'rank' => 'King' }
          ] ]
      } ],
      'current_player_index' => 0,
      'deck' => {
        'cards' => [ { 'suit' => 'Diamonds', 'rank' => 'Two' } ]
      }
    }
    game = create(:game, go_fish: go_fish_json)

    expect(game.go_fish.players.map(&:name)).to match_array [ user1.username, user2.username ]
    expect(game.go_fish.players.first.hand.first).to eq PlayingCard.new(suit: 'Clubs', rank: 'Four')
    expect(game.go_fish.deck.cards.first).to eq PlayingCard.new(suit: 'Diamonds', rank: 'Two')
  end
end
