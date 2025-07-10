class AddGoFishToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :go_fish, :jsonb
  end
end
