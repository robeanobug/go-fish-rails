require "rails_helper"

RSpec.describe GoFish do
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:player3) { Player.new('Player 3') }
  let(:player4) { Player.new('Player 4') }
  let(:gofish) { GoFish.new([player1, player2]) }
  let(:gofish_4_players) { GoFish.new([player1, player2, player3, player4]) }
  let(:gofish_hash) { GoFish.dump(gofish) }

  it "initializes with a deck, players, and current player index" do
    expect(gofish.players).to be_a Array
    expect(gofish.current_player).to be_a Player
    expect(gofish.deck).to be_a Deck
  end

  it 'should create a hash' do
    expect(gofish_hash).to be_a Hash
    expect(gofish_hash).to have_key('players')
    expect(gofish_hash).to have_key('current_player_index')
    expect(gofish_hash).to have_key('deck')
  end

  it 'should return object from json' do
    game = GoFish.load(gofish_hash)
    expect(game.players).to be_a Array
    expect(game.deck).to be_a Deck
    expect(game.current_player_index).to be_a Integer
  end
  it 'should deal out the base hand size to 2 players' do
    gofish.deal!
    expect(gofish.players.first.hand.size).to eq(GoFish::BASE_HAND_SIZE)
  end
  it 'should deal out the small hand size to 4 players' do
    gofish_4_players.deal!
    expect(gofish_4_players.players.first.hand.size).to eq(GoFish::SMALL_HAND_SIZE)
  end
end
