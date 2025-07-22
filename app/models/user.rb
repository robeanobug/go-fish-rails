class User < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :games, through: :game_users

  validates :username, presence: true
  paginates_per 20

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def active_now!
    activity_threshold = 5.minutes
    time_since_last_activity = [ Time.now - last_seen_at, 0 ].max

    if time_since_last_activity <= activity_threshold
      self.time_played ||= 0
      self.time_played += time_since_last_activity
    end

    self.last_seen_at = Time.now
    save!
  end

  def self.ransackable_attributes(auth_object = nil)
    [ 'email', 'id', 'id_value', 'last_seen_at', 'remember_created_at', 'time_played', 'total_games', 'username', 'won_games' ]
  end

  def percentage
    unless self.total_games == 0
      percent = ((self.won_games.to_f / self.total_games) * 100)
      "#{percent.round(1)}%"
    end
  end

  def time_in_game
    Time.at((self.time_played)).utc.strftime('%H:%M:%S')
  end

  def self.total_user_games
    self.all.sum(&:total_games)
  end

  def self.total_users_time_in_game
    Time.at((self.all.sum(&:time_played))).utc.strftime('%H:%M:%S')
  end
end
