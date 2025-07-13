require 'rails_helper'

RSpec.describe "Games", type: :system, js: true do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  let!(:game) { create(:game, users: [ user1 ]) }
  let(:player1) { game.find_player(user1) }
  let(:player2) { game.find_player(user2) }
  let(:ace_spades) { PlayingCard.new(rank: 'Ace', suit: 'Spades') }
  let(:two_spades) { PlayingCard.new(rank: 'Two', suit: 'Spades') }
  let(:jack_hearts) { PlayingCard.new(rank: 'Jack', suit: 'Hearts') }
  # let(:ace_hearts) { PlayingCard.new(rank: 'Ace', suit: 'Hearts') }
  # let(:ace_diamonds) { PlayingCard.new(rank: 'Ace', suit: 'Diamonds') }
  # let(:ace_clubs) { PlayingCard.new(rank: 'Ace', suit: 'Clubs') }
  # let(:king_spades) { PlayingCard.new(rank: 'King', suit: 'Spades') }
  # let(:king_hearts) { PlayingCard.new(rank: 'King', suit: 'Hearts') }
  # let(:king_diamonds) { PlayingCard.new(rank: 'King', suit: 'Diamonds') }
  # let(:king_clubs) { PlayingCard.new(rank: 'King', suit: 'Clubs') }

  def load_game_user1
    sign_in user1
    page.driver.refresh
  end

  def join_game_user2
    sign_in user2
    visit root_path
    click_on('Join')
    expect(page).to have_content('Your Hand')
    game.reload
    reset_cards
  end

  def reset_cards
    game.go_fish.players.each do |player|
      player.hand = []
      player.books = []
    end
    game.go_fish.deck = Deck.new
    game.go_fish.deal_cards
    game.save!
    page.driver.refresh
  end

  def assign_hand_to_player1(hand)
    game.go_fish.players.first.hand = hand
    game.save!
    game.reload
    page.driver.refresh
  end
  it 'should not show the join option after a player is in the game' do
    load_game_user1
    join_game_user2
    visit root_path
    expect(page).to have_no_content('Join')
  end

  describe 'deals cards to players' do
    it 'has cards displayed' do
      join_game_user2
      player2 = game.find_player(user2)
      card_rank = player2.hand.first.rank
      card_suit = player2.hand.first.suit

      expect(page).to have_css("img[alt='#{card_rank} of #{card_suit}']")
      load_game_user1
      expect(page).to have_no_css("img[alt='#{card_rank} of #{card_suit}']")
    end
  end

  describe 'display correct information' do
    before do
      join_game_user2
    end
    it 'should show opponent names' do
      within '.player-inputs' do
        expect(page).to have_text(user1.username)
      end
    end
    it 'should show the current player cards' do
      within '.player-inputs' do
        player2_card_rank = game.go_fish.players.last.hand.first.rank
        expect(page).to have_text(player2_card_rank)
      end
    end
    it 'should show a badge of whose turn it is' do
      within '.badge' do
        expect(page).to have_text 'Turn'
        expect(page).to have_text game.go_fish.current_player.name
      end
    end
  end

  describe 'play round' do
    before do
      join_game_user2
      load_game_user1
      visit game_path(game.id)
      game.reload
    end
    context 'when the turn does not change' do
      it 'should show the question' do
        click_on 'Request'
        within '.feed__container' do
          expect(page).to have_text(user1.username)
          expect(page).to have_text('asked')
          expect(page).to have_text(user2.username)
        end
      end
      it 'should show the response' do
        click_on 'Request'
        within '.feed__container' do
          expect(page).to have_text(user1.username)
          expect(page).to have_text('any').or(have_text('took'))
          expect(page).to have_no_text('drew')
          expect(page).to have_text(user2.username)
        end
      end
      xit 'should show the action' do
        click_on 'Request'
        within '.feed__container' do
          expect(page).to have_text(user1.username)
          expect(page).to have_text('asked')
          expect(page).to have_text(user2.username)
        end
      end

      it 'should display taken cards correctly for both main players and change turns' do
        load_game_user1

        expect(page).to have_no_css("img[alt='#{ace_spades.rank} of #{ace_spades.suit}']")
        click_on 'Request'
        expect(page).to have_css("img[alt='#{ace_spades.rank} of #{ace_spades.suit}']")
        game.reload
        expect(player1.hand).to include(ace_spades)
        within('.badge') { expect(page).to have_text(game.go_fish.players.first.name) }
      end
    end
    context 'when the turn changes' do
      before do
        load_game_user1
        assign_hand_to_player1([ two_spades ])
        click_on 'Request'
      end
      it 'should have a player go fish and change turns' do
        expect(page).to have_css("img[alt='#{jack_hearts.rank} of #{jack_hearts.suit}']")
        within('.badge') { expect(page).to have_text(game.go_fish.players.last.name) }
      end
      it 'should display messages in the game feed when the player goes fishing' do
        game.reload
        within '.feed__container' do
          expect(page).to have_text(user1.username)
          expect(page).to have_no_text('took')
          expect(page).to have_text('Go fish')
          expect(page).to have_text('drew')
          expect(page).to have_text(user2.username)
        end
      end
    end
  end
end
