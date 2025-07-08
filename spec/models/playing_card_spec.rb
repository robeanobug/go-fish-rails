require "rails_helper"

RSpec.describe PlayingCard do
  let(:playing_card) { PlayingCard.new('2', 'Spades')}
  fit 'has a rank and a suit' do
    expect(playing_card.rank).to eq('2')
    expect(playing_card.suit).to eq('Spades')
  end
end