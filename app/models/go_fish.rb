class GoFish
  attr_accessor :players, :current_player, :deck, :current_player_index

  BASE_PLAYER_COUNT = 2
  PLAYER_COUNT_THRESHOLD = 4
  BASE_HAND_SIZE = 7
  SMALL_HAND_SIZE = 5

  def initialize(players = [], deck = Deck.new, current_player_index = 0)
    @players = players
    @current_player = players[current_player_index]
    @deck = deck
  end

  def self.from_json(json)
    players = json['players'].map do |player_hash|
      Player.from_json(player_hash)
    end
    deck = Deck.new(json['deck']['cards'].map do |card_hash|
      binding.irb if card_hash.instance_of?(String)
      PlayingCard.new(**card_hash.symbolize_keys)
    end)
    current_player_index = json['current_player_index'] || 0
    self.new(players, deck, current_player_index)
  end

  def self.load(json)
    return nil if json.blank?
    self.from_json(json)
  end

  def self.dump(obj)
    obj.as_json
  end

  def as_json(*)
    {
      players: players.map(&:as_json),
      current_player_index: current_player_index,
      deck: deck.as_json
  }.stringify_keys
  end

  def current_player_index
    players.index(current_player)
  end

  def deal!
    deck.shuffle!
    deal_cards
  end

  def deal_cards
    if players.length >= PLAYER_COUNT_THRESHOLD
      deal_less_cards
    else
      deal_more_cards
    end
  end

  def deal_less_cards
    SMALL_HAND_SIZE.times do
      players.each do |player|
        player.add_cards(deal_card)
      end
    end
  end

  def deal_more_cards
    BASE_HAND_SIZE.times do
      players.each do |player|
        player.add_cards(deal_card)
      end
    end
  end

  def deal_card
    deck.deal_card
  end
end
