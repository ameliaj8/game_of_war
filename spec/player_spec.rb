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

    it 'adds the passed in array to the players cards array' do
      cards = [Card.new('A',2), Card.new('A',3), Card.new('A', 4)]
      player.add_cards(cards)
      expect(player.cards).to eq(cards)
      more_cards = [Card.new('A', 5), Card.new('A', 6)]
      player.add_cards(more_cards)
      expect(player.cards).to eq(cards+more_cards)
    end

    it 'raises an error if not an array of Cards' do
      expect{player.add_cards([1])}.to raise_error ('Expected an array of Cards')
    end
  end

  context '#play_card' do
    let(:player) { Player.new('foo') }

    it 'removes the first card from the array and returns it' do
      cards = [Card.new('A',2), Card.new('A',3), Card.new('A', 4)]
      player.add_cards(cards)
      expect(player.play_card).to eq(cards.first)
      expect(player.cards).to eq(cards[1..2])
    end

    it 'returns nil when no cards left' do
      expect(player.play_card).to eq(nil)
    end
  end
end