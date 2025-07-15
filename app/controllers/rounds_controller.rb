class RoundsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_game
  def create
    @game = Game.find(params[:game_id])
    if @game.play_round!(round_params[:requested_rank], round_params[:target])
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update(
            dom_id(@game, current_user.id),
            partial: 'games/game', locals: { game: @game, user: current_user }
          ) }
        format.html { redirect_to @game }
      end
      # redirect_to @game, notice: 'Round played successfully!'
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
