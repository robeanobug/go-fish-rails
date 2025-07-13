class RoundResult
  attr_reader :current_player, :target, :taken_cards, :requested_rank, :fished_card

  def initialize(current_player: nil, target: nil, requested_rank: nil, taken_cards: nil, fished_card: nil)
    @current_player = current_player
    @target = target
    @fished_card = fished_card
    @taken_cards = taken_cards
    @requested_rank = requested_rank
    # @winners = winners
  end

  def question
    "#{current_player.name} asked #{target.name} for #{requested_rank}s"
  end

  def response
    return "#{current_player.name} took #{taken_cards.count} #{requested_rank}(s) from #{target.name}" if taken_cards.any?
    "Go fish: #{target.name} does not have any #{requested_rank}s" if fished_card
  end

  def action
    return if fished_card.nil?
    "#{current_player.name} fished a #{fished_card.rank} of #{fished_card.suit}"
  end

  def as_json
    {
      current_player: current_player.as_json,
      target: target.as_json,
      requested_rank: requested_rank,
      taken_cards: taken_cards&.map { |card| { rank: card.rank, suit: card.suit }.stringify_keys },
      fished_card: fished_card ? { rank: fished_card.rank, suit: fished_card.suit }.stringify_keys : nil
    }.stringify_keys
  end

  def self.from_json(json)
    current_player = Player.from_json(json['current_player'])
    target = Player.from_json(json['target'])
    requested_rank = json['requested_rank']
    taken_cards = json['taken_cards']&.map do |card_hash|
      PlayingCard.new(**card_hash.symbolize_keys)
    end || []
    fished_card = json['fished_card'] ? PlayingCard.new(**json['fished_card'].symbolize_keys) : nil
    self.new(current_player:, target:, requested_rank:, taken_cards:, fished_card:)
  end
end
