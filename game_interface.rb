# frozen_string_literal: true

require_relative 'dealer'
require_relative 'game'
require_relative 'player'

class GameInterface
  def initialize
    @dealer = Dealer.new
  end

  def play
    introduction
    loop do
      start_game
      result = @game.run
      finish_game(result)
      break if exit_game? || user_bankrupt?
    end
    bye
  end

  private

  def introduction
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
    puts "\nHi, #{@player.name}. Game started!\n"
  end

  def start_game
    @game.start
    users_summary(false)
  end

  def users_summary(flag)
    puts @player.user_hand
    puts @dealer.user_hand(flag)
  end

  def finish_game(result)
    puts "\nGame results: \n"
    users_summary(true)
    show_bank
    puts "#{result}"
  end

  def show_bank
    puts "#{@player.name} bank: #{@player.bank}"
    puts "Dealer bank: #{@dealer.bank}"
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
