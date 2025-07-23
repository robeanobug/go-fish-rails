class Game < ApplicationRecord
  include ActionView::RecordIdentifier
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  broadcasts_refreshes

  validates :name, presence: true
  validates :player_count, numericality: { greater_than: 0, less_than_or_equal_to: 6 }
  validates :sum_of_players_and_bots, numericality: { greater_than: 0, less_than_or_equal_to: 6 }

  serialize :go_fish, coder: GoFish

  def start_if_ready!
    return false unless player_count == users.length
    add_game_to_user
    players = users.map { |user| Player.new(user.username, user.id) }
    players = players.push(bots_array).flatten
    self.go_fish = GoFish.new(players)
    go_fish.deal!
    save!
  end

  def play_round!(requested_rank, target_string)
    target = find_player(target_string)
    go_fish.play_round!(requested_rank.chop, target)
    if go_fish.over?
      add_winner_to_game(go_fish.find_winner)
      stop_clock
    end
    save!
  end

  def find_player(player_info)
    return if go_fish.blank?
    if player_info.is_a?(User)
      go_fish.players.find { |player| player.user_id == player_info.id }
    else
      go_fish.players.find { |player| player.name == player_info }
    end
  end

  def is_current_player_turn?(current_user)
    find_player(current_user) == go_fish.current_player
  end

  def turbo_stream_id(user)
    "games:#{self.id}:users:#{user.id}"
  end

  def over?
    go_fish&.over?
  end

  private

  def sum_of_players_and_bots
    bot_count = 0 if bot_count.nil?
    player_count + bot_count
  end

  def add_game_to_user
    users.each do |user|
      user.total_games += 1
      user.save!
    end
  end

  def add_game_won_to_winner(winner_player)
    winner_user = find_user(winner_player)
    if winner_player.player?
      winner_user.won_games += 1
      winner_user.save!
    end
  end

  def add_winner_to_game(winner_player)
    winner_user = find_user(winner_player)
    if winner_user
      self.winner = winner_user.id
      save!
    end
  end

  def find_user(player)
    users.find { |user| user.id == player.user_id }
  end

  def stop_clock
    self.time_played = Time.now - time_started
  end

  def bots_array
    bot_names = username_array.shuffle.take(bot_count)
    bot_names.map { |name| Bot.new("#{name}bot") }
  end

  def username_array
    [ 'Marsha Mellow', 'Chip Munk', 'Anita Bath', 'Sal Monella', 'Walter Melon', 'Major Payne', 'Joe King', "Al O'Vera", 'Kerry Oki', 'Ella Vator', 'Noah Lott', 'Willie Makeit',
  'Noah Dia', 'Candace Spencer', 'Ray D. Ater', 'Tim Burr', 'Tish Hughes', 'Holden Aseck', 'Cy Nara', 'Ty Coon', 'Polly Ester', 'Chris P. Bacon' ]
  end
end
