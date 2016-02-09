class Card
  include Comparable

  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank

    @rank_map = [2,3,4,5,6,7,8,9,10,'J','Q','K','A']
  end

  def to_s
    "#{@suit} #{@rank}"
  end

  def <=>(other)
    @rank_map.index(self.rank) <=> @rank_map.index(other.rank)
  end
end