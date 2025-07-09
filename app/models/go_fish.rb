class GoFish
  attr_accessor :players, :current_player, :deck
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
       PlayingCard.new(**card_hash.symbolize_keys)
     end)
    self.new(players, deck, json['current_player_index'])
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
end
