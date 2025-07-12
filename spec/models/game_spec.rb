require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:game) { create(:game, users: [ user1, user2 ]) }
  let(:ace_spades) { PlayingCard.new(rank: 'Ace', suit: 'Spades') }
  let(:ace_hearts) { PlayingCard.new(rank: 'Ace', suit: 'Hearts') }
  let(:ace_diamonds) { PlayingCard.new(rank: 'Ace', suit: 'Diamonds') }
  let(:ace_clubs) { PlayingCard.new(rank: 'Ace', suit: 'Clubs') }
  let(:king_spades) { PlayingCard.new(rank: 'King', suit: 'Spades') }
  let(:king_hearts) { PlayingCard.new(rank: 'King', suit: 'Hearts') }
  let(:king_diamonds) { PlayingCard.new(rank: 'King', suit: 'Diamonds') }
  let(:king_clubs) { PlayingCard.new(rank: 'King', suit: 'Clubs') }
  let(:four_clubs) { PlayingCard.new(rank: 'Four', suit: 'Clubs') }
  let(:jack_hearts) { PlayingCard.new(rank: 'Jack', suit: 'Hearts') }
  let(:jack_spades) { PlayingCard.new(rank: 'Jack', suit: 'Spades') }

  # let(:go_fish_json) do
  #   {
  #     'players' => [ {
  #       'user_id' => user1.id,
  #       'name' => user1.username,
  #       'hand' => [ { 'suit' => 'Clubs', 'rank' => 'Four' } ],
  #       'books' => [ [
  #         { 'suit' => 'Clubs', 'rank' => 'Ace' },
  #         { 'suit' => 'Diamonds', 'rank' => 'Ace' },
  #         { 'suit' => 'Spades', 'rank' => 'Ace' },
  #         { 'suit' => 'Hearts', 'rank' => 'Ace' }
  #         ] ]
  #     }, {
  #       'user_id' => user2.id,
  #       'name' => user2.username,
  #       'hand' => [ { 'suit' => 'Hearts', 'rank' => 'Jack' } ],
  #       'books' => [ [
  #         { 'suit' => 'Clubs', 'rank' => 'King' },
  #         { 'suit' => 'Diamonds', 'rank' => 'King' },
  #         { 'suit' => 'Spades', 'rank' => 'King' },
  #         { 'suit' => 'Hearts', 'rank' => 'King' }
  #         ] ]
  #     } ],
  #     'current_player' => 0,
  #     'deck' => {
  #       'cards' => [ { 'suit' => 'Diamonds', 'rank' => 'Two' } ]
  #     }
  #   }
  # end
  def setup_game
    player1 = Player.new(user1.username)
    player2 = Player.new(user2.username)
    player1.hand = [ four_clubs ]
    player2.hand = [ jack_hearts ]
    player1.books = [ [ ace_clubs, ace_diamonds, ace_spades, ace_hearts ] ]
    player1.books = [ [ king_clubs, king_diamonds, king_spades, king_hearts ] ]
    deck = Deck.new
    deck.cards = [ jack_spades ]
    GoFish.new([ player1, player2 ], deck)
  end
  it 'deflates and inflates a GoFish game from JSON' do
    game = GoFish.load(GoFish.dump(setup_game))
    expect(game.players.map(&:name)).to match_array [ user1.username, user2.username ]
    expect(game.players.first.hand.first).to eq PlayingCard.new(suit: 'Clubs', rank: 'Four')
    expect(game.deck.cards.first).to eq PlayingCard.new(suit: 'Spades', rank: 'Jack')
  end
  xit 'deflates a GoFish game from JSON' do
    game_from_json = create(:game, go_fish: go_fish_json)

    expect(game_from_json.go_fish.players.map(&:name)).to match_array [ user1.username, user2.username ]
    expect(game_from_json.go_fish.players.first.hand.first).to eq PlayingCard.new(suit: 'Clubs', rank: 'Four')
    expect(game_from_json.go_fish.deck.cards.first).to eq PlayingCard.new(suit: 'Diamonds', rank: 'Two')
  end
  it 'does not start the game when not enough players' do
    high_player_count = 5
    game.player_count = high_player_count
    expect(game.start_if_ready!).to be false
  end
  it 'starts the game when enough players' do
    low_player_count = 2
    game.player_count = low_player_count
    expect(game.start_if_ready!).to be true
  end
  describe 'play round' do
    it 'has a round result with a question' do
      game.start_if_ready!
      user1_card_rank = game.find_player(user1).hand.first.rank
      round_result = game.play_round!(user1_card_rank, user2.username)
      expect(round_result).to be true
    end
    it 'takes cards from the target and gives to the player' do
      game.start_if_ready!
      game.find_player(user1).hand = [ ace_spades ]
      game.find_player(user2).hand = [ ace_hearts ]
      game.play_round!('Aces', user2.username)
      expect(game.go_fish.players.last.hand).to eq []
      expect(game.go_fish.players.first.hand).to eq [ ace_spades, ace_hearts ]
    end
  end
end
