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
    return false unless player_count == users.count
    players = users.map { |user| Player.new(user.username, user.id) }
    bot_count.times { players << Player.new("#{Faker::Internet.username}bot") }
    self.go_fish = GoFish.new(players)
    go_fish.deal!
    save!
  end

  def play_round!(requested_rank, target_string)
    target = find_player(target_string)
    go_fish.play_round!(requested_rank.chop, target)
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

  private

  def sum_of_players_and_bots
    bot_count = 0 if bot_count.nil?
    player_count + bot_count
  end
end
