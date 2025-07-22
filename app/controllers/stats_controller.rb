class StatsController < ApplicationController
  def show
    # @q = User.active.ransack(params[:q])
    # @users = @q.result(distinct: true).page params[:page]
    @users = User.order(:username).page params[:page]
  end
end
