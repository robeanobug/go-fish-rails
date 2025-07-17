class AddBotCountToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :bot_count, :integer
  end
end
