class StatsController < ApplicationController
  def show
    @users = User.all
  end
end
