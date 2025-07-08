require 'rails_helper'

RSpec.describe "User", type: :system, chrome: true do
  describe "sign up" do
    let(:user) { build(:user) }
    it 'signs up a user' do
      visit new_user_registration_path
      expect(page).to have_text("Sign up")

      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      fill_in "user_password_confirmation", with: user.password
      click_on "Sign up"
      expect(page).to have_text("Go Fish")
    end
  end

  describe "login" do
    let!(:user) { create(:user) }

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
  
  fit 'can create a game' do
    find(".btn", text: "New Game").click
    expect(page).to have_text("Player count")
  end
end