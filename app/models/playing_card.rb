class PlayingCard
  attr_reader :rank, :suit
  RANKS = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace]
  SUITS = %w[Spades Hearts Diamonds Clubs]

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end