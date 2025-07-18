require 'rails_helper'

RSpec.describe RoundResult do
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:player3) { Player.new('Player 3') }
  let(:taken_cards) { [ PlayingCard.new(rank: 'Ace', suit: 'Clubs'), PlayingCard.new(rank: 'Ace', suit: 'Spades') ] }
  let(:fished_ace) { PlayingCard.new(rank: 'Ace', suit: 'Clubs') }
  let(:fished_two) { PlayingCard.new(rank: 'Two', suit: 'Clubs') }

  context 'when current player takes a card from target player' do
    let(:result) { RoundResult.new(current_player: player1, target: player2, requested_rank: 'Ace', taken_cards: taken_cards) }
    it 'has a question' do
      expect(result.question(player1)).to include('You', 'asked', 'for')
      expect(result.question(player2)).to include(player1.name, 'asked', 'for', 'you')
    end
    it 'has a response' do
      expect(result.response(player1)).to include('You', 'took', 'from')
      expect(result.response(player2)).to include(player1.name, 'took', 'from', 'you')
    end
  end
  context 'when current player goes fish' do
    let(:result) { RoundResult.new(current_player: player1, target: player2, requested_rank: 'Ace', fished_card: fished_ace) }

    it 'has a question' do
      expect(result.question(player1)).to include('asked', 'for')
    end
    it 'has a response' do
      expect(result.response(player1)).to include('Go fish')
      expect(result.response(player2)).to include('Go fish')
    end
    it 'has an action' do
      expect(result.action(player1)).to include('fished', fished_ace.rank)
      expect(result.action(player2)).to include('fished', 'card')
      expect(result.action(player2)).to_not include(fished_ace.rank)
    end
  end

  context 'when a player has an empty hand an draws a card' do
    it 'should send a message alerting the players that a player drew a card'
  end

  context 'when there is a winner' do
    let(:result) { RoundResult.new(winner: player1) }
    it 'should display a winner' do
      expect(result.winner_output(player1)).to include('winner')
    end
  end

  describe 'serialization' do
    let(:result) { RoundResult.new(current_player: player1, target: player2, requested_rank: 'Ace', taken_cards:) }
    it 'should create a hash' do
      round_results_hash = result.as_json
      expect(round_results_hash).to be_a Hash
      expect(round_results_hash).to have_key('current_player')
      expect(round_results_hash).to have_key('target')
      expect(round_results_hash).to have_key('taken_cards')
      expect(round_results_hash).to have_key('requested_rank')
    end
    it 'should return object from json' do
      round_results_hash = result.as_json
      round_results_hash = RoundResult.from_json(round_results_hash)
      expect(round_results_hash.current_player).to be_a Player
      expect(round_results_hash.target).to be_a Player
      expect(round_results_hash.taken_cards).to be_a Array
      expect(round_results_hash.requested_rank).to be_a String
    end
  end
end