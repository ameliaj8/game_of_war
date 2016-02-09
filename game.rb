require_relative 'card'
require_relative 'player'

class Game
  def initialize(number_of_players)
    suits = ['Diamonds', 'Spades', 'Clubs', 'Hearts']
    ranks = ['A', 'K', 'Q', 'J', 10, 9, 8, 7, 6, 5, 4, 3, 2]
    @cards = []
    suits.each do |suit|
      ranks.each do |rank|
        @cards << Card.new(suit,rank)
      end
    end

    @cards = @cards.shuffle
    number_of_cards = @cards.length

    @players = []
    count = 1

    number_of_players.times do
      @players << Player.new(count)
      count += 1
    end

    count = 0
    while @cards.length > 0 do
      if count > (@players.length-1)
        count = 0
      end
      @players[count].add_cards([@cards.pop])
      count += 1
    end
  end

  def remaining_players
    @players.size
  end

  def play
    @players =- 1
  end
end