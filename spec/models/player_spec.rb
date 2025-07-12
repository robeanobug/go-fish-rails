require 'rails_helper'

RSpec.describe Player do
  let(:player) { Player.new('Player 1') }
  let(:ace_spades) { PlayingCard.new(rank: 'Ace', suit: 'Spades') }
  let(:ace_hearts) { PlayingCard.new(rank: 'Ace', suit: 'Hearts') }
  let(:ace_diamonds) { PlayingCard.new(rank: 'Ace', suit: 'Diamonds') }
  let(:ace_clubs) { PlayingCard.new(rank: 'Ace', suit: 'Clubs') }
  let(:king_spades) { PlayingCard.new(rank: 'King', suit: 'Spades') }
  let(:king_hearts) { PlayingCard.new(rank: 'King', suit: 'Hearts') }
  let(:king_diamonds) { PlayingCard.new(rank: 'King', suit: 'Diamonds') }
  let(:king_clubs) { PlayingCard.new(rank: 'King', suit: 'Clubs') }

  before do
    player.hand = [ ace_spades, ace_hearts ]
    player.books = [ [ king_spades, king_hearts, king_diamonds, king_clubs ] ]
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
  it 'has a user_id' do
    expect(player.user_id).to be_a(Integer)
  end
  it 'adds cards to the hand' do
    player.add_cards([ ace_clubs, ace_diamonds ])
    expect(player.hand).to eq([ ace_spades, ace_hearts, ace_clubs, ace_diamonds ])
  end
  it 'adds a card to the hand' do
    player.add_cards(ace_diamonds)
    expect(player.hand).to eq([ ace_spades, ace_hearts, ace_diamonds ])
  end
  it 'shows the ranks in their hand' do
    expect(player.ranks).to eq([ 'Ace' ])
  end
  it 'removes cards from their hand' do
    player.remove_cards([ ace_spades, ace_hearts ])
    expect(player.hand).to eq []
  end
  it 'compares players and says they are equal if they have the same information'
  it 'should create a hash' do
    player_hash = player.as_json
    expect(player_hash).to be_a Hash
    expect(player_hash).to have_key('name')
    expect(player_hash).to have_key('user_id')
    expect(player_hash).to have_key('hand')
    expect(player_hash).to have_key('books')
  end
  it 'should return object from json' do
    player_hash = player.as_json
    player = Player.from_json(player_hash)
    expect(player.name).to be_a String
    expect(player.user_id).to be_a Integer
    expect(player.hand).to be_a Array
    expect(player.books).to be_a Array
  end
end
