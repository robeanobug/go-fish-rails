# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_23_132304) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_users", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_users_on_game_id"
    t.index ["user_id"], name: "index_game_users_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "player_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "go_fish"
    t.integer "bot_count"
    t.integer "winner"
    t.datetime "time_started"
    t.float "time_played"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.integer "total_games", default: 0
    t.integer "won_games", default: 0
    t.float "time_played", default: 0.0
    t.datetime "last_seen_at", default: "2025-07-22 20:30:12"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "game_users", "games"
  add_foreign_key "game_users", "users"

  create_view "leaderboards", sql_definition: <<-SQL
      SELECT users.id,
      users.username,
      count(u2.id) AS games_won,
      count(u3.id) AS games_lost,
      count(game_users.*) AS total_games,
      concat(round((((count(u2.id))::double precision / (count(game_users.*))::double precision) * (100)::double precision)), '%') AS percent,
      to_char((sum(COALESCE(games.time_played)) * 'PT1S'::interval), 'HH24:MI:SS'::text) AS time_in_game
     FROM ((((users
       JOIN game_users ON ((users.id = game_users.user_id)))
       JOIN games ON ((games.id = game_users.game_id)))
       LEFT JOIN users u2 ON (((u2.id = games.winner) AND (games.winner = users.id))))
       LEFT JOIN users u3 ON (((u3.id = games.winner) AND (games.winner <> users.id))))
    GROUP BY users.id;
  SQL
end
