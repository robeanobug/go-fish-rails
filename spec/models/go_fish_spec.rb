require 'rails_helper'

RSpec.describe GoFish do
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:player3) { Player.new('Player 3') }
  let(:player4) { Player.new('Player 4') }

  let(:gofish) { GoFish.new([ player1, player2 ]) }
  let(:gofish_4_players) { GoFish.new([ player1, player2, player3, player4 ]) }

  let(:gofish_hash) { GoFish.dump(gofish) }

  let(:ace_spades) { PlayingCard.new(rank: 'Ace', suit: 'Spades') }
  let(:ace_hearts) { PlayingCard.new(rank: 'Ace', suit: 'Hearts') }
  let(:ace_diamonds) { PlayingCard.new(rank: 'Ace', suit: 'Diamonds') }
  let(:ace_clubs) { PlayingCard.new(rank: 'Ace', suit: 'Clubs') }
  let(:king_spades) { PlayingCard.new(rank: 'King', suit: 'Spades') }
  let(:king_hearts) { PlayingCard.new(rank: 'King', suit: 'Hearts') }
  let(:king_diamonds) { PlayingCard.new(rank: 'King', suit: 'Diamonds') }
  let(:king_clubs) { PlayingCard.new(rank: 'King', suit: 'Clubs') }
  let(:two_hearts) { PlayingCard.new(rank: 'Two', suit: 'Hearts') }
  let(:two_spades) { PlayingCard.new(rank: 'Two', suit: 'Spades') }

  it "initializes with a deck, players, and current player index" do
    expect(gofish.players).to be_a Array
    expect(gofish.players).to include gofish.current_player
    expect(gofish.deck).to be_a Deck
  end

  it 'should create a hash' do
    expect(gofish_hash).to be_a Hash
    expect(gofish_hash).to have_key('players')
    expect(gofish_hash).to have_key('current_player_index')
    expect(gofish_hash).to have_key('deck')
    expect(gofish_hash).to have_key('round_results')
  end

  describe '.from_json' do
    it 'returns a player with user id, name, hand, and books' do
      player_hash = { 'user_id' => 1, 'name' => 'Bob', 'hand' => [ { 'rank' => '2', 'suit' => 'Spades' }, { 'rank' => '4', 'suit' => 'Diamonds' } ], 'books' => [] }
      expect(Player.from_json(player_hash)).to be_a Player
      expect(Player.from_json(player_hash)).to have_attributes(user_id: 1, name: 'Bob')
      expect(Player.from_json(player_hash).hand.first).to have_attributes(rank: '2', suit: 'Spades')
    end
  end

  describe '#to_json' do
    it 'returns a hash with proper attributes' do
      expect(player1.as_json['user_id']).to eq player1.user_id
      expect(player1.as_json['hand']).to eq []
      expect(player1.as_json['name']).to eq player1.name
      expect(player1.as_json['books']).to eq []
    end
  end

  it 'should return object from json' do
    gofish.deal_cards
    deck = gofish.deck
    gofish.play_round!('Ace', player2)
    game = GoFish.load(GoFish.dump(gofish))
    expect(game.players).to eq [ player1, player2 ]
    expect(game.deck.cards).to eq deck.cards
    expect(game.players).to include game.current_player
    expect(game.round_results.first.question).to include('asked')
  end
  it 'should deal out the base hand size to 2 players' do
    gofish.deal!
    expect(gofish.players.first.hand.size).to eq(GoFish::BASE_HAND_SIZE)
  end
  it 'should deal out the small hand size to 4 players' do
    gofish_4_players.deal!
    expect(gofish_4_players.players.first.hand.size).to eq(GoFish::SMALL_HAND_SIZE)
  end
  describe 'play round' do
    context "when the current player's turn stays" do
      before do
        player1.hand = [ ace_hearts, king_diamonds ]
        player2.hand = [ ace_diamonds ]
        gofish.deck.cards = [ ace_spades ]
      end
      it 'has a round result with a question' do
        round_result = gofish.play_round!('Ace', player2).last
        expect(round_result.question).to include('asked')
      end
      it 'should take a card from the opponent and give it to the current player' do
        gofish.play_round!('Ace', player2)
        expect(player1.hand).to eq([ ace_hearts, king_diamonds, ace_diamonds ])
        expect(player2.hand).to eq([])
      end
    end
  end
end
