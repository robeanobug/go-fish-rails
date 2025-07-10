class Player
  attr_reader :name
  attr_accessor :hand, :books, :user_id

  BASE_HAND_SIZE = 7
  SMALL_HAND_SIZE = 5
  BOOK_LENGTH = 4

  def initialize(name, user_id = 0, hand = [], books = [])
    @name = name
    @user_id = user_id
    @hand = hand
    @books = books
  end

  def add_cards(cards)
    if cards.is_a?(PlayingCard)
      hand << cards
    else
      cards.each { |card| hand << card }
    end
  end

  def self.from_json(json)
    hand = json['hand'].map do |card_hash|
      binding.irb unless PlayingCard.new(**card_hash&.symbolize_keys)

      PlayingCard.new(**card_hash.symbolize_keys)
    end
    books = json['books'].map do |book|
      book.map do |card_hash|
      PlayingCard.new(**card_hash.symbolize_keys)
      end
    end
    self.new(json['name'], json['user_id'], hand, books)
  end

  def as_json(*)
    {
      name: name,
      user_id: user_id,
      hand: hand.map { |card| { rank: card.rank, suit: card.suit } },
      books: books.map { |book|  book.map(&:as_json) }
    }.stringify_keys
  end
end
