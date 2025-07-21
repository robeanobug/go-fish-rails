class GoFish
  attr_accessor :players, :deck, :current_player_index, :current_player, :round_results

  BASE_PLAYER_COUNT = 2
  PLAYER_COUNT_THRESHOLD = 4
  BASE_HAND_SIZE = 7
  SMALL_HAND_SIZE = 5

  def initialize(players = [], deck = Deck.new, current_player_index = 0, round_results = [])
    @players = players
    @current_player_index = current_player_index
    @current_player = players[current_player_index]
    @deck = deck
    @round_results = round_results
  end

  def play_round!(requested_rank, target)
    taken_cards = take_cards(requested_rank, target)
    fished_card = go_fish unless taken_cards || deck.empty?
    round_results << RoundResult.new(current_player:, requested_rank:, target:, taken_cards:, fished_card:)
    round_results << RoundResult.new(winner: find_winner) if over?
    change_turns_if_possible(requested_rank, fished_card, taken_cards)
    draw_card_if_needed
    play_round!(*current_player.make_selection(opponents)) if current_player.is_a?(Bot) && !over?
    round_results
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

  def go_fish
    card = deal_card
    current_player.add_cards(card)
    card
  end

  def change_turns_if_possible(requested_rank, fished_card, taken_cards)
    return if taken_cards
    unless fished_card && requested_rank == fished_card.rank
      self.current_player_index = (players.index(current_player) + 1) % players.count
      self.current_player = players[current_player_index]
      change_turns_if_possible(requested_rank, fished_card, taken_cards) if current_player.hand.empty? && deck.empty? && !over?
    end
  end

  def self.from_json(json)
    players = json['players'].map do |player_hash|
      player_hash['user_id'].nil? ? Bot.from_json(player_hash) : Player.from_json(player_hash)
    end
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

  def draw_card_if_needed
    return if !current_player.hand.empty? || deck.empty?
    drawn_card_if_needed = deal_card
    current_player.add_cards(drawn_card_if_needed)
    round_results << RoundResult.new(drawn_card_if_needed:, current_player:)
  end

  def find_winner
    players.max_by { |player| player.books.count }
  end

  def over?
    deck.empty? && players.all? { |player| player.out_of_cards? }
  end

  def opponents
    players.reject { |player| player == current_player }
  end
end
