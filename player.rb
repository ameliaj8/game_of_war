class Player
  attr_reader :name, :cards
  def initialize(name)
    @name = name
    @cards = []
  end

  def to_s
    "Player #{@name}"
  end

  def add_cards(cards)
    raise 'Expected an array of Cards' if cards.detect{|c| !c.is_a?(Card)}
    @cards += cards
    @cards.shuffle!
  end

  def play_card
    @cards.shift
  end
end