class Leaderboard < ApplicationRecord
  belongs_to :user
  paginates_per 20

  def self.ransackable_attributes(auth_object = nil)
    [ 'id', 'username', 'games_won', 'games_lost', 'total_games', 'percent', 'time_in_game' ]
  end

  def readonly?
    true
  end
end
