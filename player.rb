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
    @cards += cards
  end

  def play_card
    @cards.shift
  end
end