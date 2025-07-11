class Deck
  attr_accessor :cards
  DECK_COUNT = 52
  def initialize(cards = build_deck)
    @cards = cards
  end

  def build_deck
    PlayingCard::RANKS.map do |rank|
      PlayingCard::SUITS.map do |suit|
        PlayingCard.new(rank: rank, suit: suit)
      end
    end.flatten
  end

  def deal_card
    cards.pop
  end

  def shuffle!
    cards.shuffle!
  end
end
