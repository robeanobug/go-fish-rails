require "rails_helper"

RSpec.describe PlayingCard do
  let(:playing_card) { PlayingCard.new(rank: 'Two', suit: 'Spades') }
  let(:playing_card2) { PlayingCard.new(rank: 'Two', suit: 'Spades') }
  it 'has a rank and a suit' do
    expect(playing_card.rank).to eq('Two')
    expect(playing_card.suit).to eq('Spades')
  end
  it 'compares 2 cards to equal each other if the rank and suits are the same' do
    expect(playing_card).to eq(playing_card2)
  end
end
