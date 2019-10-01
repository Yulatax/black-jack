# frozen_string_literal: true

require_relative 'game'

class GameInterface

  def initialize
    greeting
    @player_name = player_name
    @game = Game.new(@player_name)
  end

  def play
    start_notification
    loop do
      start_game
      run_game
      finish_game(@winner)
      break if exit_game? || @game.user_bankrupt?
    end
    bye
  end

  private

  def greeting
    puts 'Welcome to Black Jack!'
  end

  def player_name
    puts 'Please, enter your name:'
    gets.chomp
  end

  def start_notification
    puts "\nHi, #{@player_name}. Game started!\n"
  end

  def start_game
    @game.start
    puts users_summary(false)
  end

  def run_game
    loop do
      user_plays
      if @game.next?
        puts 'Action is not available!'
        next
      else
        puts @game.player_summary
      end
      break if stop?

      dealer_plays
      break if stop?
    end
    @winner = @game.define_winner
  end

  def users_summary(flag)
    puts @game.player_summary
    puts @game.dealer_summary(flag)
  end

  def choose_action
    puts @game.actions
    gets.chomp
  end

  def user_plays
    action = @game.define_choice(choose_action)
    @game.user_action(action)
  end

  def dealer_plays
    puts "\nDealer plays...\n"
    @game.dealer_action
    puts @game.dealer_action_text
    puts @game.dealer_summary(false)
  end

  def stop?
    @game.stop?
  end

  def finish_game(result)
    puts "\nGame results: \n"
    puts users_summary(true)
    show_bank
    puts "#{result}"
  end

  def show_bank
    puts @game.bank
  end

  def exit_game?
    puts 'Start new game? Enter any key or 1 to exit.'
    gets.chomp.to_i == 1
  end

  def bye
    puts 'The game is over. Bye!'
  end
end
