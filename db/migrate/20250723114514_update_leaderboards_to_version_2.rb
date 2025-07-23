class UpdateLeaderboardsToVersion2 < ActiveRecord::Migration[8.0]
  def change
    update_view :leaderboards, version: 2, revert_to_version: 1
  end
end
