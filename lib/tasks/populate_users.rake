namespace :data do
  desc 'This task populates the database'
  task populate: :environment do |t, args|
    # binding.irb
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
    end
  end
end
