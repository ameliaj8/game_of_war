require_relative '../player'

RSpec.describe Player do
  context '#initialize' do
    it 'sets the name and cards' do
      player = Player.new('myname')
      expect(player.name).to eq('myname')
      expect(player.cards).to eq([])
    end
  end

  context '#to_s' do
    it 'prints the Player name' do
      expect(Player.new('Foo').to_s).to eq('Player Foo')
    end
  end

  context '#add_cards' do
    let(:player) { Player.new('foo') }

    context 'player has no cards' do
      it 'adds the passed in array to the players cards array' do
        cards = [Card.new('A',2), Card.new('A',3), Card.new('A', 4)]
        before_cards = player.cards
        player.add_cards(cards)
        (before_cards+cards).each do |c|
          expect(player.cards).to include(c)
        end
      end
    end

    context 'player already has some cards' do
      before do
        cards = [Card.new('A',2), Card.new('A',3), Card.new('A', 4)]
        player.add_cards(cards)
      end

      it 'adds the passed in array to the players cards array' do
        before_cards = player.cards
        more_cards = [Card.new('A', 5), Card.new('A', 6)]
        player.add_cards(more_cards)
        (before_cards+more_cards).each do |c|
          expect(player.cards).to include(c)
        end
      end
    end

    it 'raises an error if not an array of Cards' do
      expect{player.add_cards([1])}.to raise_error ('Expected an array of Cards')
    end

    it 'shuffles the players cards after adding the new cards' do
      expect_any_instance_of(Array).to receive(:shuffle!)
      player.add_cards([Card.new('A', 2)])
    end
  end

  context '#play_card' do
    let(:player) { Player.new('foo') }

    it 'removes the first card from the array and returns it' do
      cards = [Card.new('A',2), Card.new('A',3), Card.new('A', 4)]
      player.add_cards(cards)
      first_card = player.cards.first
      expect(player.play_card).to eq(first_card)
      expect(player.cards.size).to eq(2)

      cards.delete_if{|c| c == first_card}.each do |c|
        expect(player.cards).to include(c)
      end
    end

    it 'returns nil when no cards left' do
      expect(player.play_card).to eq(nil)
    end
  end
end