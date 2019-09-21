require_relative 'dealer'
require_relative 'game'
require_relative 'player'

class GameInterface

  def initialize
    @dealer = Dealer.new
  end

  def play
    start
    @game.run
  end

  private

  def start
    greeting
    @player = Player.new(player_name)
    @game = Game.new(dealer: @dealer, player: @player)
    start_notification
  end

  def greeting
    puts 'Welcome to Black Jack!'
  end

  def player_name
    puts 'Please, enter your name:'
    gets.chomp
  end

  def start_notification
    puts "Hi, #{@player.name}. Game started!"
  end
end
