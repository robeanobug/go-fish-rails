# terminal: rails data:populate\[10,10]

namespace :data do
  desc 'This task populates the database rails data:populate\[user_count,game_count]'
  task populate: :environment do |t, args|
    user_count_arg = args.extras[0].to_i
    game_count_arg = args.extras[1].to_i

    user_count_arg.times.each_with_index do |i|
      User.create(
        email: "user#{i}@example.com",
        username: "User#{i}",
        password: 'password',
        password_confirmation: 'password'
      )
    end
    total_user_count = User.count
    game_count_arg.times do |i|
      offset = rand(total_user_count)
      users = User.offset(offset).first((2..5).to_a.sample)
      game = Game.create(name: "Game#{i}", users: users, bot_count: 0, player_count: users.count)
      game.start_if_ready!
      # play random number of rounds or all the way through
      game.time_started = Time.now - (0..30).to_a.sample.days - (0..24).to_a.sample.hours
      game.winner = users.sample.id
      game.time_played = (0..5).to_a.sample.hours + (0..59).to_a.sample.minutes + (0..59).to_a.sample.seconds
      game.save!
    end
  end
end
