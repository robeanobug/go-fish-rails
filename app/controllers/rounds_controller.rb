class RoundsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_game
  def create
    @game = Game.find(params[:game_id])
    if @game.play_round!(round_params[:requested_rank], round_params[:target])
      redirect_to game_path(@game)
    else
      redirect_to @game, unprocessable_entity
    end
  end

  private

  def round_params
    params.require(:round).permit(:requested_rank, :target)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
