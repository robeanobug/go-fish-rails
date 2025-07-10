require 'rails_helper'

RSpec.describe "Games", type: :system, js: true do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  let!(:game) { create(:game, users: [ user1 ]) }

  def load_game_user1
    sign_in user1
    visit root_path
    click_on(game.name)
    expect(page).to have_text('Your Hand')
  end

  def load_game_user2
    sign_in user2
    visit root_path
    click_on('Join')
    expect(page).to have_content('Your Hand')
    game.reload
  end
  it 'should not show the join option after a player is in the game' do
    load_game_user1
    load_game_user2
    visit root_path
    expect(page).to have_no_content('Join')
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

  describe 'displays correct form information' do
    before do
      load_game_user2
    end
    it 'should show opponent names' do
      within '.player-inputs' do
        expect(page).to have_text(user1.username)
      end
    end
    fit 'should show the current player cards' do
      within '.player-inputs' do
        player2_card_rank = game.go_fish.players.last.hand.first.rank
        expect(page).to have_text(player2_card_rank)
      end
    end
  end
end
