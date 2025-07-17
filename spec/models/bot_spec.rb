require 'rails_helper'
RSpec.describe Bot do
  let(:player1) { Player.new('Name') }
  let(:ace_hearts) { PlayingCard.new(rank: 'Ace', suit: 'Hearts') }
  let(:opponents) { [ player1 ] }
  let(:bot) { Bot.new(player1.name) }

  before do
    bot.add_cards(ace_hearts)
  end
  it 'has a player' do
    expect(bot.make_selection([ player1 ])).to eq([ 'Ace', player1 ])
  end
  it 'should create a hash' do
    bot_hash = bot.as_json
    expect(bot_hash).to be_a Hash
    expect(bot_hash).to have_key('name')
    expect(bot_hash).to have_key('hand')
    expect(bot_hash).to have_key('books')
  end
  it 'should return object from json' do
    bot_hash = bot.as_json
    bot = Bot.from_json(bot_hash)
    expect(bot.name).to be_a String
    expect(bot.hand).to be_a Array
    expect(bot.books).to be_a Array
  end
end
