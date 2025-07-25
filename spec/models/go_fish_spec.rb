require 'rails_helper'

RSpec.describe GoFish do
  let(:player1) { Player.new('Player 1', 1) }
  let(:player2) { Player.new('Player 2', 2) }
  let(:player3) { Player.new('Player 3', 3) }
  let(:player4) { Player.new('Player 4', 4) }
  let(:bot1) { Bot.new('Bot') }

  let(:gofish) { GoFish.new([ player1, player2 ]) }
  let(:gofish_3_players) { GoFish.new([ player1, player2, bot1 ]) }
  let(:gofish_4_players) { GoFish.new([ player1, player2, player3, player4 ]) }
  let(:gofish_with_bot) { GoFish.new([ player1, bot1 ]) }

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
    gofish_json = GoFish.dump(gofish)
    # binding.irb
    game = GoFish.load(gofish_json)
    expect(game.players).to eq [ player1, player2 ]
    expect(game.deck.cards).to eq deck.cards
    expect(game.players).to include game.current_player
    expect(game.round_results.first.question(player1)).to include('asked')
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
        round_result = gofish.play_round!('Ace', player2)
        round_result = round_result.last
        expect(round_result.question(player1)).to include('asked')
      end
      it 'should take a card from the opponent and give it to the current player' do
        gofish.play_round!('Ace', player2)
        expect(player1.hand).to eq([ ace_hearts, king_diamonds, ace_diamonds ])
        expect(player2.hand).to eq([])
      end
    end
    context "when the current player's turn changes" do
      before do
        player1.hand = [ ace_hearts, king_diamonds ]
        player2.hand = [ ace_diamonds ]
      end
      it 'player1 goes fish and does not pull their requested card' do
        gofish.deck.cards = [ ace_spades ]
        gofish.play_round!('King', player2)
        expect(player1.hand).to eq([ ace_hearts, king_diamonds, ace_spades ])
        expect(player2.hand).to eq([ ace_diamonds ])
        expect(gofish.current_player_index).to eq 1
        expect(gofish.current_player).to eq player2
      end
      it 'should change turns if current a player requests a rank, does not get it, and can not draw a fished_card because the deck is empty' do
        gofish.deck.cards = []
        gofish.play_round!('King', player2)
        expect(gofish.current_player).to eq player2
      end
    end
    context 'when a player creates a book with their last cards' do
      before do
        player1.hand = [ ace_hearts, ace_diamonds, ace_spades ]
        player2.hand = [ ace_clubs ]
        gofish.deck.cards = [ two_spades, king_hearts ]
      end
      it 'should deal a card to the current player' do
        gofish.play_round!('Ace', player2)
        expect(player1.books).to eq [ [ ace_hearts, ace_diamonds, ace_spades, ace_clubs ] ]
        expect(player1.hand).to eq [ king_hearts ]
      end
    end
    context 'when the game is over' do
      before do
        gofish.players.each { |player| player.books = [] }
        gofish.deck.cards = []
        player1.hand = [ace_diamonds, ace_spades]
        player2.hand = [ace_hearts, ace_clubs]
      end
      it 'should display the winner' do
        result = gofish.play_round!('Ace', player2)
        expect(result.last.winner_output(player2)).to include("winner", player1.name)
      end
      it 'should not display the winner' do
        gofish.deck.cards = [ king_spades ]
        result = gofish.play_round!('Ace', player2)
        expect(result.last.winner_output(player1)).to be nil
      end
    end
  end
  it 'should play a bots turn at the end of a users' do
    player1.hand = [ ace_hearts, king_diamonds ]
    bot1.hand = [ king_clubs ]

    gofish_with_bot.deck.cards = [ two_spades, two_hearts ]

    gofish_with_bot.play_round!(ace_diamonds.rank, bot1)

    expect(gofish_with_bot.current_player).to eq(player1)
  end
  it 'should play a bots turn at the end of a users' do
    player1.hand = [ ace_hearts, king_diamonds ]
    player2.hand = [ ace_diamonds ]
    bot1.hand = [ king_clubs ]

    gofish_with_bot.deck.cards = [ two_spades, two_hearts, ace_spades ]

    gofish_with_bot.play_round!(king_diamonds.rank, player2)
    gofish_with_bot.play_round!(ace_diamonds.rank, bot1)

    expect(gofish_with_bot.current_player).to eq(player1)
  end
  it 'should display when a player has to draw a card at the beginning of their turn' do
    player1.hand = [ ace_diamonds ]
    player2.hand = [ ace_hearts ]
    gofish.deck.cards = [ two_hearts, two_spades ]
    gofish.play_round!('Ace', player2)
    gofish.play_round!('Ace', player2)
    expect(player2.hand).to eq [ two_hearts ]
    expect(gofish.round_results.last.drew_card(player1)).to include('ran out of cards')
  end
  it 'should skip the current player turn if they do not have any cards and the deck is out' do
    gofish_3_players.players.first.hand = [ ace_diamonds ]
    gofish_3_players.players[1].hand = []
    gofish_3_players.deck.cards = []
    gofish_3_players.play_round!('Ace', gofish_3_players.players[1])
    expect(gofish_3_players.current_player).to eq player1
  end
end
