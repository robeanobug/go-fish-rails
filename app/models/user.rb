class User < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :games, through: :game_users

  validates :username, presence: true

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
end
