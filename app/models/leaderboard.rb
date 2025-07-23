class Leaderboard < ApplicationRecord
  belongs_to :user
  paginates_per 20

  def self.ransackable_attributes(auth_object = nil)
    [ 'user_id', 'time_played', 'total_games', 'username', 'won_games' ]
  end

  def readonly?
    true
  end
end
