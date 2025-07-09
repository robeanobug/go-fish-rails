class Player
  attr_reader :name
  attr_accessor :hand, :books

  BASE_HAND_SIZE = 7
  SMALL_HAND_SIZE = 5
  BOOK_LENGTH = 4

  def initialize(name, hand = [], books = [])
    @name = name
    @hand = hand
    @books = books
  end

  def self.dump(obj)
    obj.as_json
  end

  def self.load(json)
    return nil if json.blank?
    self.from_json(json)
  end

  def self.from_json(json)
    hand = json['hand'].map { |card_hash| PlayingCard.new(**card_hash.symbolize_keys) }
    books = json['books'].map do |book|
      book.map { |card_hash| PlayingCard.new(**card_hash.symbolize_keys) }
    end
    self.new(json['name'], hand, books)
  end

  def as_json(*)
    {
      name: name,
      hand: hand.map(&:as_json),
      books: books.map { |book|  book.map(&:as_json) },
    }.stringify_keys
  end
end
