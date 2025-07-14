require 'rails_helper'

RSpec.describe Deck do
  let(:deck) { Deck.new }
  it 'has a specified deck length' do
    expect(deck.cards.length).to eq Deck::DECK_COUNT
  end
  it 'holds playing cards' do
    expect(deck.cards.first).to be_a(PlayingCard)
  end
  it 'deals a card' do
    expect(deck.deal_card).to be_a(PlayingCard)
  end
  it 'should shuffle the deck' do
    unshuffled_deck = deck.cards.dup
    deck.shuffle!
    expect(unshuffled_deck).to match_array deck.cards
    expect(unshuffled_deck).to_not eq deck.cards
  end
  it 'should return true if empty' do
    deck.cards = []
    expect(deck.empty?).to be true
  end
end
