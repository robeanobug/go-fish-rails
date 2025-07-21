class AddGamesInfoToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :total_games, :integer, default: 0
    add_column :users, :won_games, :integer, default: 0
  end
end
