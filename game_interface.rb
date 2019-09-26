# frozen_string_literal: true

require_relative 'dealer'
require_relative 'game'
require_relative 'player'

class GameInterface
  def initialize
    @dealer = Dealer.new
  end

  def play
    start
    loop do
      result = @game.run
      puts result
      break if exit_game? || user_bankrupt?
    end
    bye
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

  def exit_game?
    puts 'Start new game? Enter any key or 1 to exit.'
    gets.chomp.to_i == 1
  end

  def user_bankrupt?
    @player.bank.zero? || @dealer.bank.zero?
  end

  def bye
    puts 'The game is over. Bye!'
  end
end
