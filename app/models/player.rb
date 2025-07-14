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
      self.hand << cards
    else
      cards.each { |card| self.hand << card }
    end
    create_book_if_possible
  end

  def remove_cards(cards)
    self.hand -= cards
  end

  def ranks
    hand.map(&:rank).uniq
  end

  def out_of_cards?
    hand.empty?
  end

  def ==(other_player)
    name == other_player.name &&
    user_id == other_player.user_id &&
    hand == other_player.hand &&
    books == other_player.books
  end

  def self.from_json(json)
    hand = json['hand'].map { |card_hash| PlayingCard.new(**card_hash.symbolize_keys) }
    books = json['books'].map { |book| book.map { |card_hash| PlayingCard.new(**card_hash.symbolize_keys) } }
    self.new(json['name'], json['user_id'], hand, books)
  end

  def as_json
    {
      name: name,
      user_id: user_id,
      hand: hand.map { |card| { rank: card.rank, suit: card.suit }.stringify_keys },
      books: books.map { |book| book.map { |card| { rank: card.rank, suit: card.suit }.stringify_keys } }
    }.stringify_keys
  end

  private

  def create_book_if_possible
    book = find_book
    if book
      books << book
      self.hand -= book
    end
  end

  def find_book
    cards_grouped_by_rank = hand.group_by(&:rank)
    cards_grouped_by_rank.values.find do |card_group|
      card_group.length == BOOK_LENGTH
    end
  end
end
