class AddTimePlayedToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :time_started, :datetime
    add_column :games, :time_played, :float
  end
end
