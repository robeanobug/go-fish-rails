namespace :data do
  desc 'This task populates the database'
  task populate: :environment do
    100.times.each_with_index do |i|
      User.create(
        email: "user#{i}@example.com",
        username: "User#{i}",
        password: 'password',
        password_confirmation: 'password'
      )
    end
    user_count = User.count
    100.times do
      offset = rand(user_count)
      users = User.offset(offset).first((2..5).to_a.sample)
      game = Game.create(users: users, bot_count: 0, player_count: user_count)
      game.start_if_ready!
      # play random number of rounds or all the way through
    end
  end
end
