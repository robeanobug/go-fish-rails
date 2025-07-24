class RemoveStatsDataFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :total_games, :integer
    remove_column :users, :won_games, :integer
    remove_column :users, :time_played, :float
    remove_column :users, :last_seen_at, :datetime
  end
end
