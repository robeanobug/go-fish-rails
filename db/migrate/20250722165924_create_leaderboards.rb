class CreateLeaderboards < ActiveRecord::Migration[8.0]
  def change
    create_view :leaderboards
  end
end


# CONCAT(CAST(ROUND(100*SUM(users.won_games)/(SELECT SUM(users.total_games) FROM users), 0) as int), '%') AS Winning_Percentage,
# SUM(users.time_played) AS Total_Time_Played