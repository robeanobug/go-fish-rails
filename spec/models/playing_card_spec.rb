require "rails_helper"

RSpec.describe PlayingCard do
  let(:playing_card) { PlayingCard.new(rank: 'Two', suit: 'Spades')}
  it 'has a rank and a suit' do
    expect(playing_card.rank).to eq('Two')
    expect(playing_card.suit).to eq('Spades')
  end
end
