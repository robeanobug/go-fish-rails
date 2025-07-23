 SELECT users.username,
    1 AS total_games,
    2 AS games_won,
    3 AS percent,
    4 AS time_in_game
   FROM users
     JOIN game_users ON users.id = game_users.user_id
     JOIN games ON games.id = game_users.game_id