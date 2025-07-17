class Bot < Player
  def initialize(name, hand = [], books = [])
    @name = name
    @hand = hand
    @books = books
  end

  def make_selection(opponents)
    [ ranks.sample, opponents.sample ]
  end

  def as_json
    {
      name: name,
      hand: hand.map { |card| { rank: card.rank, suit: card.suit }.stringify_keys },
      books: books.map { |book| book.map { |card| { rank: card.rank, suit: card.suit }.stringify_keys } }
    }.stringify_keys
  end

  def self.from_json(json)
    hand = json['hand'].map { |card_hash| PlayingCard.new(**card_hash.symbolize_keys) }
    books = json['books'].map { |book| book.map { |card_hash| PlayingCard.new(**card_hash.symbolize_keys) } }
    self.new(json['name'], hand, books)
  end
end
