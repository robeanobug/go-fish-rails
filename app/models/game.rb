class Game < ApplicationRecord
  validates :name, presence: true
  validates :player_count, numericality: { greater_than: 1, less_than: 7 }
end
