class RoundResult
  attr_reader :current_player, :target, :taken_cards, :requested_rank, :fished_card, :winner

  def initialize(current_player: nil, target: nil, requested_rank: nil, taken_cards: nil, fished_card: nil, winner: nil)
    @current_player = current_player
    @target = target
    @fished_card = fished_card
    @taken_cards = taken_cards
    @requested_rank = requested_rank
    @winner = winner
  end

  def question(player)
    "#{subject(player)} asked #{recipient(player)} for #{requested_rank}s"
  end

  def response(player)
    return "#{subject(player)} took #{taken_cards.count} #{requested_rank}(s) from #{recipient(player)}" unless fished_card
    "Go fish: #{recipient(player)} does not have any #{requested_rank}s"
  end

  def action(player)
    return if fished_card.nil?
    return "#{subject(player)} fished a #{fished_card.rank} of #{fished_card.suit}" if subject(player) == 'You'
    "#{subject(player)} fished a card"
  end

  def winner_output(player)
    "#{subject(player)} the winner with #{winner.books.count} books!" if winner
  end

  def subject(player)
    return player.name == current_player.name ? 'You' : current_player.name if current_player
    player.name == winner.name ? 'You are' : "#{winner.name} is" if winner
  end

  def recipient(player)
    player.name == target.name ? 'you' : target.name
  end

  def as_json
    {
      current_player: current_player.as_json,
      target: target.as_json,
      requested_rank: requested_rank,
      taken_cards: taken_cards&.map { |card| { rank: card.rank, suit: card.suit }.stringify_keys },
      fished_card: fished_card ? { rank: fished_card.rank, suit: fished_card.suit }.stringify_keys : nil,
      winner: winner.as_json
    }.stringify_keys
  end

  def self.from_json(json)
    current_player = json['current_player'] ? Player.from_json(json['current_player']) : nil
    target = json['target'] ? Player.from_json(json['target']) : nil
    requested_rank = json['requested_rank']
    taken_cards = json['taken_cards']&.map { |card_hash| PlayingCard.new(**card_hash.symbolize_keys) } || []
    fished_card = json['fished_card'] ? PlayingCard.new(**json['fished_card'].symbolize_keys) : nil
    winner = json['winner'] ? Player.from_json(json['winner']) : nil
    self.new(current_player:, target:, requested_rank:, taken_cards:, fished_card:, winner:)
  end
end
