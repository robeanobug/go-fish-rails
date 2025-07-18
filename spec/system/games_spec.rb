require 'rails_helper'

RSpec.describe "Games", type: :system do
  include ActiveJob::TestHelper

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }

  let!(:game) { create(:game, users: [ user1 ]) }
  let!(:game_three_players) { create(:game, name: 'Three Player Game', player_count: 3, users: [ user1, user2, user3 ]) }
  let!(:bot_game) { build(:game, player_count: 1, name: 'Bot Game', users: [ user1 ], bot_count: 1) }
  let!(:bot_game_three_players) { create(:game, name: 'Bot Game Three Players', users: [ user1, user2 ], bot_count: 1) }

  let!(:bot_game_unjoined_user) { create(:game, name: 'Bot Game Unjoined User', users: [ user1 ], bot_count: 1) }


  let(:player1) { game.find_player(user1) }
  let(:player2) { game.find_player(user2) }
  let(:player3) { game.find_player(user3) }

  let(:ace_spades) { PlayingCard.new(rank: 'Ace', suit: 'Spades') }
  let(:ace_hearts) { PlayingCard.new(rank: 'Ace', suit: 'Hearts') }
  let(:ace_diamonds) { PlayingCard.new(rank: 'Ace', suit: 'Diamonds') }
  let(:ace_clubs) { PlayingCard.new(rank: 'Ace', suit: 'Clubs') }
  let(:two_spades) { PlayingCard.new(rank: 'Two', suit: 'Spades') }
  let(:jack_hearts) { PlayingCard.new(rank: 'Jack', suit: 'Hearts') }
  let(:jack_diamonds) { PlayingCard.new(rank: 'Jack', suit: 'Diamonds') }
  let(:king_spades) { PlayingCard.new(rank: 'King', suit: 'Spades') }
  let(:king_hearts) { PlayingCard.new(rank: 'King', suit: 'Hearts') }
  let(:king_diamonds) { PlayingCard.new(rank: 'King', suit: 'Diamonds') }
  let(:king_clubs) { PlayingCard.new(rank: 'King', suit: 'Clubs') }

  def join_game_user(user)
    sign_in user
    visit root_path
    within(find('.card', text: game.name)) { click_on('Join') }
    expect(page).to have_content('Your Hand')
    game.reload
    reset_cards(game)
  end

  def reset_cards(game)
    game.go_fish.players.each do |player|
      player.hand = []
      player.books = []
    end
    game.go_fish.deck = Deck.new
    game.go_fish.deal_cards
    game.save!
    visit game_path(game)
  end

  def assign_hand_to_player(player, hand)
    player.hand = hand
    game.save!
    game.reload
    page.driver.refresh
  end

  def play_round_twice(rank, game)
    select rank, from: 'Rank'
    click_on 'Request'
    select rank, from: 'Rank'
    click_on 'Request'
  end

  it 'should not show the join option after a player is in the game' do
    sign_in user1
    join_game_user(user2)
    visit root_path
    within(find('.card', text: game.name)) { expect(page).to have_no_content('Join') }
    # expect(page).to have_no_content('Join')
  end

  describe 'deals cards to players' do
    it 'has cards displayed', chrome: true do
      join_game_user(user2)
      player2 = game.find_player(user2)
      card_rank = player2.hand.first.rank
      card_suit = player2.hand.first.suit
      expect(page).to have_css("img[alt='#{card_rank} of #{card_suit}']")
      sign_in user1
      page.driver.refresh
      expect(page).to have_no_css("img[alt='#{card_rank} of #{card_suit}']")
    end
  end

  describe 'display correct information' do
    before do
      join_game_user(user2)
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

  describe 'play round two players' do
    before do
      join_game_user(user2)
      sign_in user1
      visit game_path(game.id)
      game.reload
      sign_in user1
    end
    context 'when the turn does not change' do
      it 'should show the question' do
        click_on 'Request'
        within '.feed__container' do
          expect(page).to have_text('asked')
        end
      end
      it 'should show a game response' do
        click_on 'Request'
        within '.feed__container' do
          expect(page).to have_text('any').or(have_text('took'))
        end
      end
      it 'should not show the action' do
        click_on 'Request'
        click_on 'Request'
        within '.feed__container' do
          expect(page).to have_text('You asked')
          expect(page).to have_no_text('fished')
          expect(page).to have_no_text(player1.name)
        end
      end
      it 'should display taken cards correctly for both main players' do
        expect(page).to have_no_css("img[alt='#{jack_diamonds.rank} of #{jack_diamonds.suit}']")
        select 'Jacks', from: 'Rank'
        click_on 'Request'
        expect(page).to have_css("img[alt='#{jack_diamonds.rank} of #{jack_diamonds.suit}']")
        game.reload
        expect(player1.hand).to include(jack_diamonds)
      end
      it 'should keep turn' do
        expect(page).to have_no_css("img[alt='#{jack_diamonds.rank} of #{jack_diamonds.suit}']")
        select 'Jacks', from: 'Rank'
        click_on 'Request'
        within('.badge') { expect(page).to have_text(game.go_fish.players.first.name) }
      end
      it 'should stay the same turn if the player fishes the requested card'
    end
    context 'when the turn changes' do
      before do
        sign_in user1
        assign_hand_to_player(player1, [ two_spades ])
        click_on 'Request'
      end
      it 'should have a player go fish and change turns' do
        expect(page).to have_css("img[alt='#{jack_hearts.rank} of #{jack_hearts.suit}']")
        within('.badge') { expect(page).to have_text(game.go_fish.players.last.name) }
      end
      it 'should display messages in the game feed when the player goes fishing' do
        game.reload
        within '.feed__container' do
          expect(page).to have_text('You')
          expect(page).to have_no_text('took')
          expect(page).to have_text('Go fish')
          expect(page).to have_text('fished')
          expect(page).to have_text(user2.username)
        end
      end
    end
    context 'when a player creates a book' do
      before do
        click_on 'Request'
      end
      it 'should remove the cards from the player hand' do
        within('.panel--sub', text: 'Your Hand') do
          within('.hand') do
            expect(page).to have_no_css("img[alt='#{ace_spades.rank} of #{ace_spades.suit}']")
          end
        end
      end
      it 'should display the book' do
        within('.panel--sub', text: 'Books') do
          within('.hand') do
            expect(page).to have_css("img[alt='#{ace_spades.rank}s book']")
          end
        end
      end
    end
    context 'when a player tries to play out of turn' do
      it 'should not let an opponent play' do
        sign_in user2
        page.driver.refresh
        expect(page).to have_text(user1.username)
        within('.player-inputs') do
          expect(page).to have_field('Player', disabled: true)
          expect(page).to have_field('Rank', disabled: true)
          expect(page).to have_button('Request', disabled: true)
        end
      end
      xit 'should not let the current player play' do
        within('.player-inputs') do
          expect(page).to have_field('Player', disabled: false)
          expect(page).to have_field('Rank', disabled: false)
          expect(page).to have_button('Request', disabled: false)
        end
      end
    end
    context 'when a player creates a book with their last cards' do
      it 'should deal a card to the current player' do
        assign_hand_to_player(player1, [ ace_spades, ace_hearts, ace_diamonds ])
        assign_hand_to_player(player2, [ ace_clubs ])
        click_on 'Request'
        within('.panel--sub', text: 'Your Hand') do
          within('.hand') do
            expect(page).to have_css("img[alt='#{jack_hearts.rank} of #{jack_hearts.suit}']")
          end
        end
      end
    end
    context 'when a player tries to draw a card and the deck is empty' do
      it 'should not draw a card if the player tries to go fish' do
        assign_hand_to_player(player1, [ ace_spades ])
        assign_hand_to_player(player2, [])
        game.go_fish.deck.cards = []
        game.save!
        click_on 'Request'
        expect(player1.hand).to eq [ ace_spades ]
      end
      xit 'should skip the player if the player runs out of cards' do
        assign_hand_to_player(player1, [ ace_spades ])
        assign_hand_to_player(player2, [])
        game.go_fish.deck.cards = []
        game.save!
        click_on 'Request'
      end
    end
    context 'when a player takes the last cards from their opponent'
    context 'when all the cards are in books'

    context 'when all the cards are in books' do
      before do
        game.go_fish.players.each { |player| player.books = [] }
        player1.hand = [ace_diamonds, ace_spades]
        player2.hand = [ace_hearts, ace_clubs]
        game.go_fish.deck.cards = []
        game.save!
        visit game_path(game)
      end
      it 'should display the winner' do
        click_on 'Request'
        within '.feed__container' do
          expect(page).to have_text('You')
          expect(page).to have_text('winner')
        end
      end
    end

    # NEED TO FIX THIS TEST IT IS BROKEN
    xit 'updates both users games automatically with turbo streams' do
      sign_in user2
      game.play_round!('Aces', player2.name)
      within '.feed__container' do
        expect(page).to have_text('asked')
      end
    end
  end
  context 'should display the opponent player accordion' do
    before do
      join_game_user(user2)
      sign_in user1
      visit game_path(game.id)
      game.reload
      sign_in user1
    end
    it 'has an accordion' do
      expect(page).to have_css(".accordion")
    end
    it 'shows the player name' do
      current_player_name = player1.name
      opponent_name = player2.name
      within ".players-content" do
        expect(page).to have_content(opponent_name)
        expect(page).to have_no_content(current_player_name)
      end
    end
    it 'shows the player card count and books count' do
      opponent = player2
      within ".players-content" do
        expect(page).to have_content(opponent.hand.count)
        expect(page).to have_content(opponent.books.count)
      end
    end
  end

  it 'should sort the cards' do
    # put data test id on the parent
    # element = first element
  end
  context 'bot player' do
    it 'should create a bot player' do
      sign_in user1
      visit root_path
      click_on 'New Game'
      expect(page).to have_text('Bot count')
    end
    it 'should start deal cards with a bot player' do
      sign_in user2
      visit root_path
      parent_element = find('.card', text: bot_game_unjoined_user.name)
      within(parent_element) { click_on('Join') }
      expect(page).to have_css('.accordion')
    end
    it 'should show the bot player in the player-inputs' do
      sign_in user1
      bot_game.start_if_ready!
      visit game_path(bot_game)
      within('.player-inputs') { expect(page).to have_text(bot_game.go_fish.players.last.name) }
    end

    xit 'should take a turn' do
      bot_game_three_players.start_if_ready!
      sign_in user1
      reset_cards(bot_game_three_players)

      play_round_twice('Jacks', bot_game_three_players)
      sign_in user2
      page.driver.refresh
      play_round_twice('Aces', bot_game_three_players)

      within('.badge') { expect(page).to have_text(user1.username) }
    end
    it 'should start the game when there is one player and a bot' do
      sign_in user1
      visit games_path
      click_on 'New Game'
      fill_in 'Name', with: bot_game.name
      fill_in 'Player count', with: bot_game.player_count
      fill_in 'Bot count', with: bot_game.bot_count
      click_on 'Create game'
      click_on bot_game.name

      expect(page).to have_css('.badge')
    end
  end

  fit 'should play the whole game through', chrome: true do
    sign_in user1
    bot_game.start_if_ready!
    visit game_path(bot_game)
    loop do
      click_on 'Request'
      expect(page).to have_content('asked')
      bot_game.reload
      exit if bot_game.go_fish.over?
    end
    expect(page).to have_content('winner')
  end
  it 'should output that the person with more books is the winner' do
    sign_in user1
    bot_game.start_if_ready!
    bot_game.go_fish.players.each { |player| player.hand = [] }
    bot_game.go_fish.deck.cards = []
    bot_game.go_fish.players.first.hand = [ king_clubs, king_hearts ]
    bot_game.go_fish.players.last.hand = [ king_spades, king_diamonds ]
    bot_game.go_fish.players.first.books = [ [ ace_hearts, ace_spades, ace_diamonds, ace_clubs ] ]
    bot_game.go_fish.players.last.books = []
    bot_game.save!
    visit game_path(bot_game)
    click_on 'Request'
    # binding.irb
    expect(page).to have_field('Player')
    within('.player-inputs') { expect(page).to have_button('Request', disabled: true) }
    expect(page).to have_content('You')
  end
end
