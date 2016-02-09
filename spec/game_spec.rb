require_relative '../game'
require_relative '../card'
require_relative '../player'

RSpec.describe Game do
  context '#initialize' do
    let(:game) { Game.new(3) }
    it 'creates the number of players specified as Player objects' do
      expect(game.players.size).to eq(3)
      game.players.each do |p|
        expect(p).to be_instance_of(Player)
      end
    end

    it 'creates a deck of cards' do
      expect(game.cards.size).to eq(52)

      game.cards.each do |c|
        expect(c).to be_instance_of(Card)
      end

      suits = ['Diamonds', 'Spades', 'Clubs', 'Hearts']
      ranks = ['A', 'K', 'Q', 'J', 10, 9, 8, 7, 6, 5, 4, 3, 2]

      suits.each do |suit|
        ranks.each do |rank|
          expect(game.cards).to include(Card.new(suit,rank))
        end
      end
    end

    it 'assigns the cards to the players in round-robin' do
      expect(game.players[0].cards.size).to eq(18)
      expect(game.players[1].cards.size).to eq(17)
      expect(game.players[2].cards.size).to eq(17)
    end
  end

  context '#remaining_players' do
    it 'returns the number of players still in the game' do
      game = Game.new(5)
      expect(game.remaining_players).to eq(5)
    end
  end

  context '#play' do
    let(:game) { Game.new(2) }
    let(:card1) { Card.new('A', 2) }
    let(:card2) { Card.new('A', 3) }

    it 'plays a card from each remaining player' do
      expect(game.players.first).to receive(:play_card).and_return(card1)
      expect(game.players.last).to receive(:play_card).and_return(card2)
      game.play
    end

    it 'adds the pile of cards to the winner of the round' do
      allow(game.players.first).to receive(:play_card).and_return(card1)
      allow(game.players.last).to receive(:play_card).and_return(card2)
      expect(game.players.last).to receive(:add_cards).with([card1, card2])
      game.play
    end

    it 'removes players with no cards left' do
      allow(game.players.first).to receive(:play_card).and_return(card1)
      allow(game.players.last).to receive(:play_card).and_return(card2)
      allow(game.players.first).to receive(:cards).and_return([])
      expect(game.remaining_players).to eq(2)
      game.play
      expect(game.remaining_players).to eq(1)
    end

    it 'returns the winning player of the round' do
      allow(game.players.first).to receive(:play_card).and_return(card1)
      allow(game.players.last).to receive(:play_card).and_return(card2)
      allow(game.players.first).to receive(:cards).and_return([])
      winner = game.players.last
      expect(game.play.name).to eq(winner.name) #compare winner's names
    end

    context 'war' do
      let(:card2) { Card.new('B', 2) }
      let(:card3) { Card.new('A', 3) }
      let(:card4) { Card.new('B', 3) }
      let(:card5) { Card.new('A', 4) }
      let(:card6) { Card.new('B', 5) }
      before do
        allow(game.players.first).to receive(:play_card).and_return(card1)
        allow(game.players.last).to receive(:play_card).and_return(card2)
      end

      it 'removes players with less than 2 cards remaining and adds their cards to the pile' do
        allow(game.players.first).to receive(:cards).and_return([card3],[card3],[])
        allow(game.players.last).to receive(:cards).and_return([card4, card5])
        expect(game.players.first).to receive(:play_card).twice.and_return(card1,card3)
        allow(game.players.last).to receive(:play_card).once.and_return(card2)
        game.play
      end

      it 'draws 2 more cards from each player' do
        expect(game.players.first).to receive(:play_card).exactly(3).times.and_return(card1,card3,card4)
        expect(game.players.last).to receive(:play_card).exactly(3).times.and_return(card2,card5,card6)
        game.play
      end

      it "keeps drawing 2 more cards for each player until there's a winner" do
        expect(game.players.first).to receive(:play_card).exactly(5).times.and_return(card1,card3,card5,card5,card5)
        expect(game.players.last).to receive(:play_card).exactly(5).times.and_return(card2,card4,card5,card6,card6)
        game.play
      end

      it "adds all the cards drawn to the winner's pile" do
        allow(game.players.first).to receive(:play_card).exactly(5).times.and_return(card1,card3,card5,card5,card5)
        allow(game.players.last).to receive(:play_card).exactly(5).times.and_return(card2,card4,card5,card6,card6)
        expect(game.players.last).to receive(:add_cards).with([card1,card2,card3,card4,card5,card5,card5,card6,card5,card6])
        game.play
      end

      context 'draw' do
        it 'raises an error when there are no players with cards left' do
          allow(game.players.first).to receive(:cards).and_return([])
          allow(game.players.last).to receive(:cards).and_return([])
          expect{game.play}.to raise_error("It's a tie between Player 1 & Player 2!")
        end
      end

      context 'more than 2 players' do
        let(:game) { Game.new(3) }
        context 'not all players have highest cards' do
          it 'keeps all players in the war while they have cards left' do
            expect(game.players[0]).to receive(:play_card).exactly(3).times.and_return(card2,card1,card4)
            expect(game.players[1]).to receive(:play_card).exactly(3).times.and_return(card3,card1,card5)
            expect(game.players[2]).to receive(:play_card).exactly(3).times.and_return(card3,card1,card6)
            game.play
          end
        end
      end
    end
  end
end