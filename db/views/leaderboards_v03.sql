SELECT
  users.id,
  users.username,
  COUNT(u2.id) AS games_won,
  COUNT(u3.id) AS games_lost,
  COUNT(game_users) AS total_games,
  CONCAT(ROUND(CAST(COUNT(u2.id) AS FLOAT)/COUNT(game_users)*100), '%') AS percent,
  TO_CHAR((SUM(COALESCE(games.time_played)) * INTERVAL '1 sec'), 'HH24:MI:SS') AS time_in_game
FROM users
INNER JOIN game_users ON users.id = game_users.user_id
INNER JOIN games ON games.id = game_users.game_id
LEFT OUTER JOIN users u2 ON u2.id = games.winner AND games.winner = users.id
LEFT OUTER JOIN users u3 ON u3.id = games.winner AND games.winner <> users.id
GROUP BY users.id