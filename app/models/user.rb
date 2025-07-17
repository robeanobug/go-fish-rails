class User < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :games, through: :game_users

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
