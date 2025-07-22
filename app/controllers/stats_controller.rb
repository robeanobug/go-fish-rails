class StatsController < ApplicationController
  def show
    # @users = User.all
    @users = User.order(:username).page params[:page]
  end
end
