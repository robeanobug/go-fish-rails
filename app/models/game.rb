class Game < ApplicationRecord
  include ActionView::RecordIdentifier
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  # after_update -> { update_streams }

  broadcasts_refreshes

  validates :name, presence: true
  validates :player_count, numericality: { greater_than: 1, less_than_or_equal_to: 6 }

  serialize :go_fish, coder: GoFish

  def start_if_ready!
    return false unless player_count == users.count
    players = users.map { |user| Player.new(user.username, user.id) }
    self.go_fish = GoFish.new(players)
    go_fish.deal!
    save!
  end

  def play_round!(requested_rank, target_string)
    target = find_player(target_string)
    fish = go_fish
    fish.play_round!(requested_rank.chop, target)
    self.go_fish = fish
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
end
