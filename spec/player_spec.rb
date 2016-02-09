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
    it 'adds the passed in array to the players cards array' do
      player = Player.new('foo')
      player.add_cards([1,2,3])
      expect(player.cards).to eq([1,2,3])
      player.add_cards([4,5])
      expect(player.cards).to eq([1,2,3,4,5])
    end
  end

  context '#play_card' do
    it 'removes the first card from the array and returns it' do
      player = Player.new('foo')
      player.add_cards([1,2,3])
      expect(player.play_card).to eq(1)
      expect(player.cards).to eq([2,3])
    end
  end
end