class RoundResult
  attr_reader :current_player, :target, :taken_cards, :requested_rank

  def initialize(current_player: nil, target: nil, requested_rank: nil, taken_cards: nil)
    @current_player = current_player
    @target = target
    # @fished_card = fished_card
    @taken_cards = taken_cards
    @requested_rank = requested_rank
    # @winners = winners
  end

  def question
    "#{current_player.name} asked #{target.name} for #{requested_rank}s"
  end

  def response
    "#{current_player.name} took #{taken_cards.count} #{requested_rank}(s) from #{target.name}" if taken_cards
  end

  # def action
    
  # end
  
  def as_json
    {
      current_player: current_player.as_json,
      target: target.as_json,
      requested_rank: requested_rank,
      taken_cards: taken_cards&.map { |card| { rank: card.rank, suit: card.suit } }
    }.stringify_keys
  end

  def self.from_json(json)
    current_player = Player.from_json(json['current_player'])
    target = Player.from_json(json['target'])
    requested_rank = json['requested_rank']
    taken_cards = json['taken_cards']&.map do |card_hash|
      PlayingCard.new(**card_hash.symbolize_keys)
    end || []
    self.new(current_player:, target:, requested_rank:, taken_cards:)
  end
end
