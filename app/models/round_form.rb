class RoundForm
  include ActiveModel::Model
  attr_accessor :requested_rank, :target

  validates :requested_rank, presence: true
  validates :target, presence: true
end
