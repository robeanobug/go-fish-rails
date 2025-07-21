require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:game) { build(:game) }

  def load_index(user)
    sign_in user
    visit "/"
  end
  def create_game
    find(".btn", text: "New Game").click
    expect(page).to have_text("Player count")
    fill_in "game[name]", with: game.name
    fill_in "game[player_count]", with: game.player_count
    fill_in "game[bot_count]", with: game.bot_count
    click_on "Create game"
  end
  describe "sign up" do
    let(:build_user) { build(:user) }
    it 'signs up a user' do
      visit new_user_registration_path
      expect(page).to have_text("Sign up")
      fill_in "user_username", with: build_user.username
      fill_in "user_email", with: build_user.email
      fill_in "user_password", with: build_user.password
      fill_in "user_password_confirmation", with: build_user.password
      click_on "Sign up"
      expect(page).to have_text("Go Fish")
    end
  end
  describe "login" do
    def login_user
      visit "/"
      expect(page).to have_content("Log in")

      fill_in "user[email]", with: user.email
      expect(page).to have_field('user[email]', with: user.email)
      fill_in "user[password]", with: user.password
      expect(page).to have_field('user[password]', with: user.password)

      click_on "Log in"
    end
    it 'can login with sign_in user' do
      sign_in user
      visit "/"
      expect(page).to have_text("Go Fish")
    end
    it 'can login manually' do
      login_user
      expect(page).to have_text("Go Fish")
    end
  end
  describe "user create game" do
    before do
      load_index(other_user)
      create_game 
    end

    it 'can create a game' do
      expect(page).to have_text(game.name)
      expect(page).to have_text("Play")
      expect(page).to have_text("Edit")
      expect(page).to have_text("Delete")
    end
    it 'should not switch the player who is in charge to the player who joins' do
      load_index(user)
      click_on "Join"
      expect(page).to have_text('Your Hand')
      click_on "Back to games"
      expect(page).to have_text(game.name)
      expect(page).to have_text("Play")
      expect(page).to have_no_text("Delete")
    end
  end

  describe "user destroy game" do
    before do
      load_index(user)
      create_game
    end
    it 'can destroy a game' do
      expect(page).to have_text(game.name)
      click_on "Delete", match: :first
      expect(page).to have_no_text(game.name)
    end
  end

  describe "showing a game" do
    before do
      load_index(user)
      create_game
    end
    it 'shows a game' do
      expect(page).to have_text(game.name)
      click_on game.name
      expect(page).to have_text(game.name)
      expect(page).to have_text("Back to games")
    end
  end
  describe "showing a profile page" do
    it 'should have a profile' do
      load_index(user)
      expect(page).to have_text('Profile')
      click_on 'Profile'
      expect(page).to have_text('Username')
    end
  end
  describe "showing a stats page" do
    it 'should have a stats' do
      load_index(user)
      expect(page).to have_text('Stats')
      click_on 'Stats'
      expect(page).to have_text('Leaderboard')
    end
  end
end
