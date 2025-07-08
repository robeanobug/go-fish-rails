class GameUsersController < ApplicationController
  def create
    @game_user = GameUser.new(game_user_params)
    @game_user.game.users << @game_user.user
    redirect_to @game_user.game
  end

  private

  def game_user_params
    params.permit(:user_id, :game_id)
  end
end
