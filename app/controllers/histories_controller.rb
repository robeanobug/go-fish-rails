class HistoriesController < ApplicationController
  def index
    @games = Game.all
  end
end
