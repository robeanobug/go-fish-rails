class AddTimePlayedToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :time_played, :float, default: 0
  end
end
