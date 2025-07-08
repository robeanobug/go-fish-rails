class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.integer :player_count, null: false

      t.timestamps
    end
  end
end
