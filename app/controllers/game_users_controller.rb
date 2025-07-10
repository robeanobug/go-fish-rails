class GameUsersController < ApplicationController
  def create
    # @game = Game.find(params[:format])
    # current_user.games << @game
    # binding.irb
    # @game.users << current_user
    
    # @game.start!
    # redirect_to @game

    @game_user = GameUser.new(game_user_params)
    @game = Game.find(params[:game_id])

    if !@game.users.include?(@game_user) && @game.users.count < @game.player_count
      @game.users << @game_user.user
      @game.start!

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
