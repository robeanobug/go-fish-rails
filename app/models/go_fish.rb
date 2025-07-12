class GoFish
  attr_accessor :players, :deck, :current_player_index, :current_player, :round_results

  BASE_PLAYER_COUNT = 2
  PLAYER_COUNT_THRESHOLD = 4
  BASE_HAND_SIZE = 7
  SMALL_HAND_SIZE = 5

  def initialize(players = [], deck = Deck.new, current_player_index = 0, round_results = [])
    @players = players
    @current_player = players[current_player_index]
    @deck = deck
    @round_results = round_results
  end

  def play_round!(requested_rank, target)
    taken_cards = take_cards(requested_rank, target)
    round_results << RoundResult.new(current_player:, requested_rank:, target:, taken_cards:)
  end

  def take_cards(requested_rank, target)
    cards = target.hand.select { |card| card.rank == requested_rank }
    unless cards.empty?
      target.remove_cards(cards)
      current_player.add_cards(cards)
      return cards
    end
    nil
  end

  def self.from_json(json)
    players = json['players'].map { |player_hash| Player.from_json(player_hash) }
    deck = Deck.new(json['deck']['cards'].map { |card_hash| PlayingCard.new(**card_hash.symbolize_keys) })
    current_player_index = json['current_player_index'].to_i
    round_results = json['round_results']&.map { |round_results_hash| RoundResult.from_json(round_results_hash) }  || []
    self.new(players, deck, current_player_index, round_results)
  end

  def self.load(json)
    return nil if json.blank?
    self.from_json(json)
  end

  def self.dump(obj)
    obj.as_json
  end

  def as_json
    {
      players: players.map(&:as_json),
      current_player_index: current_player_index.to_s,
      deck: deck.as_json,
      round_results: round_results.map(&:as_json)
    }.stringify_keys
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
