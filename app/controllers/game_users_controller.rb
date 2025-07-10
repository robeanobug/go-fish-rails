class GameUsersController < ApplicationController
  def create
    @game_user = GameUser.new(game_user_params)

    if @game_user.save
      @game_user.game.start_if_ready!

      redirect_to @game_user.game
    else
      redirect_to games_path, status: :unprocessable_entity
    end
  end

  private

  def game_user_params
    params.permit(:user_id, :game_id)
  end
end
