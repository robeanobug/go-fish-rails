require 'rails_helper'

RSpec.describe "User", type: :system, chrome: true do
  let!(:user) { create(:user) }
  let(:game) { build(:game) }

  def load_index
    sign_in user
    visit "/"
  end
  
  def create_game
    find(".btn", text: "New Game").click
    expect(page).to have_text("Player count")
    fill_in "game[name]", with: game.name
    fill_in "game[player_count]", with: game.player_count
    click_on "Create game"
  end

  describe "sign up" do
    let(:build_user) { build(:user) }
    it 'signs up a user' do
      visit new_user_registration_path
      expect(page).to have_text("Sign up")

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
      load_index
    end

    it 'can create a game' do
      create_game
      expect(page).to have_text(game.name)
    end
  end
  
  describe "user destroy game" do
    before do
      load_index
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
      load_index
      create_game
    end

    it 'shows a game' do
      expect(page).to have_text(game.name)
      click_on game.name
      expect(page).to have_text(game.name)
      expect(page).to have_text("Back to games")
    end
  end
end