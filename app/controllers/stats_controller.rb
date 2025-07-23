class StatsController < ApplicationController
  def show
    @q = Leaderboard.ransack(params[:q])
    @leaderboards = @q.result.page params[:page]
  end
end
