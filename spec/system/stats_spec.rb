require 'rails_helper'

RSpec.describe "Stats", type: :system do
  let!(:user) { create(:user) }
  before do
    sign_in user
    visit stat_path(user)
    expect(page).to have_content('Leaderboard')
  end
  it 'should show the number games played' do
    expect(page).to have_text('Total Games')
    expect(page).to have_text('Games Won')
    expect(page).to have_text('Winning percentage')
    expect(page).to have_text('Total Time Played')
  end
end