require 'rails_helper'

RSpec.describe "Games", type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  let!(:game) { create(:game, users: [ user1, user2 ]) }

  def load_game_user1
    sign_in user1
    visit "/"
    click_link(game.name)
  end

  def load_game_user2
    sign_in user2
    visit "/"
    click_link(game.name)

  end
  describe 'deals cards to players' do
    before do
      load_game_user1
    end
    it 'shows the game page' do
      expect(page).to have_text("Your Hand")
    end
  end
end