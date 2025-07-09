class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  validates :name, presence: true
  validates :player_count, numericality: { greater_than: 1, less_than_or_equal_to: 6 }

  attr_accessor :go_fish

  serialize :go_fish, coder: GoFish

  # def start!
  #   return false unless player_count == users.count

  #   players = users.map { |user| Player.new(user.id) }
  #   go_fish = GoFish.new(players)
  #   go_fish.deal!
  #   update(go_fish: go_fish)
  # end

  # def play_round!
  #   go_fish.play_round!
  #   save!
  # end
end
