class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

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
    go_fish.play_round!(requested_rank.chop, target)
    save!
  end

  def find_player(player_info)
    if player_info.is_a?(User)
      go_fish.players.find { |player| player.user_id == player_info.id }
    else
      go_fish.players.find { |player| player.name == player_info }
    end
  end
end
