require 'rails_helper'

RSpec.describe "Games", type: :system, chrome: true do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  let!(:game) { create(:game, users: [ user1 ]) }

  def load_game_user1
    sign_in user1
    visit root_path
    click_on(game.name)
  end

  def load_game_user2
    sign_in user2
    visit root_path
    click_on('Join')
    expect(page).to have_content('Your Hand')
    game.reload
  end
  describe 'cannot join the same game twice' do
    before do
      load_game_user1
    end
    it 'shows the game page' do
      expect(page).to have_text('Your Hand')
    end
    it 'cannot join the same game twice' do
      load_game_user2
      visit root_path
      click_on 'Join'
      expect(page).to have_content('Your Games')
    end
  end

  describe 'deals cards to players' do
    it 'has cards displayed' do
      load_game_user2
      player2 = game.find_player(user2)
      card_rank = player2.hand.first.rank
      card_suit = player2.hand.first.suit

      expect(page).to have_css("img[alt='#{card_rank} of #{card_suit}']")
      load_game_user1
      expect(page).to have_no_css("img[alt='#{card_rank} of #{card_suit}']")
    end
  end
end
