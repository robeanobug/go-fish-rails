require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:game) { create(:game, users: [ user1, user2 ]) }

  let(:go_fish_json) do
    {
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
  end
  it 'inflates a GoFish game from JSON' do
    game = create(:game, go_fish: go_fish_json)

    expect(game.go_fish.players.map(&:name)).to match_array [ user1.username, user2.username ]
    expect(game.go_fish.players.first.hand.first).to eq PlayingCard.new(suit: 'Clubs', rank: 'Four')
    expect(game.go_fish.deck.cards.first).to eq PlayingCard.new(suit: 'Diamonds', rank: 'Two')
  end
  fit 'does not start the game when not enough players' do
    high_player_count = 5
    game.player_count = high_player_count
    expect(game.start_if_ready!).to be false
  end
  fit 'starts the game when enough players' do
    low_player_count = 2
    game.player_count = low_player_count
    what_is_this = game.start_if_ready!
    expect(what_is_this).to be true
  end
end
