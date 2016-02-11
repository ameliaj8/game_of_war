require_relative 'card'
require_relative 'player'

class Game
  attr_reader :players, :cards

  def initialize(number_of_players)
    suits = ['Diamonds', 'Spades', 'Clubs', 'Hearts']
    ranks = ['A', 'K', 'Q', 'J', 10, 9, 8, 7, 6, 5, 4, 3, 2]
    @cards = []
    suits.each do |suit|
      ranks.each do |rank|
        @cards << Card.new(suit,rank)
      end
    end

    @cards.shuffle!

    @players = []
    count = 1

    number_of_players.times do
      @players << Player.new(count)
      count += 1
    end

    count = 0
    @cards_copy = @cards.dup
    while @cards_copy.length > 0 do
      if count > (@players.length-1)
        count = 0
      end
      @players[count].add_cards([@cards_copy.pop])
      count += 1
    end
  end

  def remaining_players
    @players.size
  end

  def play
    puts "=================PLAYING A ROUND================="
    cards = []

    winner = nil

    while true do
      puts "PLAYERS = #{@players.map{|p| p.to_s}.join(", ")}"
      cards += @players.map{|p| p.play_card} if !cards.empty? #place a card face down into pile
      war_cards = @players.map{|p| p.play_card} #face up cards

      war_max_card = war_cards.max
      cards += war_cards

      puts "WAR CARDS = #{war_cards.map{|c| c.to_s}.join(", ")}"
      puts "MAX CARD = #{war_max_card}"

      if war_cards.select{|c| c == war_max_card}.size == 1
        winner = @players[war_cards.index(war_max_card)]
        break #we have a winner
      end

      @players.each_index do |i|
        if @players[i].cards.length < 2
          #this player is out of the game and their cards go to the pile
          while @players[i].cards.length > 0
            cards << @players[i].play_card
          end
        end
      end

      if @players.select{|p| p.cards.length > 0}.size == 0 # 0 players left
        fail "It's a tie between #{@players.map{|p| p.to_s}.join(" & ")}!"
      end

      @players.reject!{|p| p.cards.length == 0}

      puts "STILL IN THE WAR #{@players.map{|p| p.to_s}.join(", ")}"

      if @players.size == 1
        winner = @players.first
        break
      end
    end

    puts "WAR WINNER = #{winner}"
    winner.add_cards(cards)

    @players.reject!{|p| p.cards.length == 0}

    winner
  end
end