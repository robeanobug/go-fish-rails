class RoundsController < ApplicationController
  before_action :set_game

  def create
    if @game.play_round!(round_params[:requested_rank], round_params[:target])
      result = @game.go_fish.round_results.last
      current_player = @game.go_fish.current_player

      ActionCable.server.broadcast("game_#{@game.id}", broadcast_data(result, current_player))

      redirect_to @game, notice: 'Round played successfully!'
    else
      redirect_to @game, status: :unprocessable_entity
    end
  end

  private

  def broadcast_data(result, current_player)
    {
      question: result.question(current_player),
      response: result.response(current_player),
      action: result.action(current_player),
      winner_output: result.winner_output(current_player),
      fished_card: result.fished_card
    }.stringify_keys
  end

  def round_params
    params.require(:round).permit(:requested_rank, :target)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
