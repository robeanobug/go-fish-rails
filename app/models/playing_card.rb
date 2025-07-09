class PlayingCard
  attr_reader :rank, :suit
  RANKS = %w[Two Three Four Five Six Seven Eight Nine Ten Jack Queen King Ace]
  SUITS = %w[Spades Hearts Diamonds Clubs]

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end
end
