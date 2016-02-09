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
    number_of_cards = @cards.length

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

    war_players = @players

    winner = nil

    while true do
      puts "PLAYERS = #{war_players.map{|p| p.to_s}.join(", ")}"
      cards += war_players.map{|p| p.play_card} if !cards.empty?#place a card face down into pile
      war_cards = war_players.map{|p| p.play_card} #face up cards

      war_max_card = war_cards.max
      cards += war_cards

      puts "WAR CARDS = #{war_cards.map{|c| c.to_s}.join(", ")}"
      puts "MAX CARD = #{war_max_card}"

      if war_cards.select{|c| c == war_max_card}.size == 1
        winner = war_players[war_cards.index(war_max_card)]
        break #we have a winner
      end

      next_war_players = [] #everyone participates unless they're out of cards http://www.pagat.com/war/war.html
      war_cards.each_index do |i|
        if war_players[i].cards.length >= 2
          next_war_players << war_players[i] 
        else
          #this player is out of the game and their cards go to the pile
          while war_players[i].cards.length > 0
            cards << war_players[i].play_card
          end
        end
      end

      puts "STILL IN THE WAR #{next_war_players.map{|p| p.to_s}.join(", ")}"

      if next_war_players.size == 1
        winner = next_war_players.first
        break
      elsif next_war_players.size > 1
        war_players = next_war_players
      else # 0 players left
        fail "It's a tie between #{war_players.map{|p| p.to_s}.join(" & ")}!"
      end

      #puts "WAR PLAYERS SIZE = #{war_players.length}"
      #puts "CARDS = #{cards.map{|c| c.to_s}.join(", ")}"
      #puts "CARDS SIZE = #{cards.length}"
    end

    puts "WAR WINNER = #{winner}"
    winner.add_cards(cards)

    # @players.each do |p|
    #   puts "#{p}'s cards #{p.cards.length}"
    #   puts p.cards.map{|c| c.to_s}.join(", ")
    # end

    @players.reject!{|p| p.cards.length == 0}

    winner
  end
end