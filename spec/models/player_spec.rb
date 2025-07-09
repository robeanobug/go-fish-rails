require "rails_helper"

RSpec.describe Player do
  let(:player) { Player.new('Player 1') }
  let(:player_hash) { Player.as_json(player) }
  let(:ace_spades) { PlayingCard.new(rank: 'Ace', suit: 'Spades') }
  let(:ace_hearts) { PlayingCard.new(rank: 'Ace', suit: 'Hearts') }
  let(:ace_diamonds) { PlayingCard.new(rank: 'Ace', suit: 'Diamonds') }
  let(:ace_clubs) { PlayingCard.new(rank: 'Ace', suit: 'Clubs') }
  let(:king_spades) { PlayingCard.new(rank: 'King', suit: 'Spades') }
  let(:king_hearts) { PlayingCard.new(rank: 'King', suit: 'Hearts') }
  let(:king_diamonds) { PlayingCard.new(rank: 'King', suit: 'Diamonds') }
  let(:king_clubs) { PlayingCard.new(rank: 'King', suit: 'Clubs') }

  before do
    player.hand = [ace_spades, ace_hearts]
    player.books = [[king_spades, king_hearts, king_diamonds, king_clubs]]
  end
  it 'has a name' do
    expect(player.name).to eq('Player 1')
  end
  it 'has a hand' do
    expect(player.hand).to be_a(Array)
  end
  it 'has books' do
    expect(player.books).to be_a(Array)
  end
  it 'should create a hash' do
    expect(player_hash).to be_a Hash
    expect(player_hash).to have_key('name')
    expect(player_hash).to have_key('hand')
    expect(player_hash).to have_key('books')
  end
  it 'should return object from json' do
    player = Player.from_json(player_hash)
    expect(player.name).to be_a String
    expect(player.hand).to be_a Array
    expect(player.books).to be_a Array
  end
end
