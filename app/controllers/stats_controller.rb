class StatsController < ApplicationController
  def show
    @q = Leaderboard.ransack(params[:q])
    @q.sorts = 'id asc' if @q.sorts.empty?
    @leaderboards = @q.result.page params[:page]
  end
end
