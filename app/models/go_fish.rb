class GoFish
  def self.from_json(json)
    players = json['players'].map do |player_hash|
      Player.from_json(player_hash)
    end
    deck = Deck.new(json['deck']['cards'].map do |card_hash|
       Card.new(**card_hash.symbolize_keys)
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
    }
  end
end