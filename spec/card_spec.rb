require_relative '../card'

RSpec.describe Card do
  context '#initialize' do
    it 'sets the suit and rank' do
      card = Card.new('suit', 2)
      expect(card.suit).to eq('suit')
      expect(card.rank).to eq(2)
    end

    it 'raises an error with bad rank' do
      expect{Card.new('suit', 'foo')}.to raise_error('Rank must be one of 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A')
    end
  end

  context '#to_s' do
    it 'prints the Card suit and rank' do
      expect(Card.new('Foo', 2).to_s).to eq('Foo 2')
    end
  end

  context '<=>' do
    it 'allows cards to be compared by rank' do
      expect(Card.new('A', 3)).to be > Card.new('A', 2)
      expect(Card.new('A', 2)).to be < Card.new('A', 3)
      expect(Card.new('A', 2)).to eq(Card.new('A', 2))
    end

    it 'ignores suit' do
      expect(Card.new('A', 2)).to eq(Card.new('B', 2))
    end
  end
end