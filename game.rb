# frozen_string_literal: true

require_relative 'bank_module'
require_relative 'deck'

class Game
  include Bank

  BLACKJACK = 21

  attr_reader :player, :dealer

  def initialize(args = {})
    @bank = 0
    @player = args[:player]
    @dealer = args[:dealer]
  end

  def start
    @deck = Deck.new
    @player.restore_actions
    @dealer.restore_actions
    card_distribution
    bank_contribution
  end

  def run
    @finish = false
    loop do
      break if @finish

      user_action
    end
    @result = define_winner
  end

  private

  def card_distribution
    @player.clear_hand
    @dealer.clear_hand
    2.times { take_card(@player) }
    2.times { take_card(@dealer) }
  end

  def bank_contribution
    contribute_to_game_bank(@player, 10)
    contribute_to_game_bank(@dealer, 10)
  end

  def take_card(user)
    user.hand << @deck.take_card
  end

  def contribute_to_game_bank(user, sum)
    user.reduce_bank(sum)
    increase_bank(sum)
  end

  def hand_limit_reached?
    @player.hand_limit? && @dealer.hand_limit?
  end

  def user_action
    return @finish = true if hand_limit_reached?

    choice = @player.actions[actions.to_i]

    case choice
    when 'skip action'
      skip_action
    when 'add card'
      add_card
    when 'open cards'
      @finish = true
    else
      puts 'Choose action or enter 0 to exit'
    end
  end

  def actions
    txt = "\n#{@player.name}, choose your action, please: \n"
    @player.actions.each_with_index do |action, index|
      txt += "#{index} - #{action}\n"
    end
    puts txt
    gets.chomp
  end

  def skip_action
    @player.remove_action('skip action')
    puts "\nDealer plays...\n"
    dealer_action
  end

  def add_card
    if @player.hand.length == 2
      take_card(@player)
      @player.remove_action('add card')
      puts @player.user_hand
      dealer_action
    else
      user_action
    end
  end

  def dealer_action
    return @finish = true if hand_limit_reached? || @dealer.points == BLACKJACK

    if @dealer.points > 17 && @dealer.actions.include?('skip action')
      puts "\nDealer skips an action!\n"
      @dealer.remove_action('skip action')
    else
      dealer_add_card
    end
    user_action
  end

  def dealer_add_card
    return unless @dealer.hand.length == 2

    take_card(@dealer)
    puts "\nDealer has taken a card!\n"
    puts @dealer.user_hand
  end

  def define_winner
    if player_win?
      reward_winner(@player)
      'You are a winner!'
    elsif dealer_win?
      reward_winner(@dealer)
      'Dealer is a winner!'
    elsif points_equal?
      reward_users
      'Dead heat!'
    else
      'No winner!'
    end
  end

  def points_equal?
    @player.points == @dealer.points
  end

  def player_win?
    (@player.points > @dealer.points && points_in_boards?) ||
      (@dealer.points > BLACKJACK && @player.points <= BLACKJACK)
  end

  def dealer_win?
    (@dealer.points > @player.points && points_in_boards?) ||
      (@dealer.points <= BLACKJACK && @player.points > BLACKJACK)
  end

  def points_in_boards?
    @dealer.points <= BLACKJACK && @player.points <= BLACKJACK
  end

  def reward_users
    @dealer.increase_bank(@bank / 2)
    @player.increase_bank(@bank / 2)
    reduce_bank(@bank)
  end

  def reward_winner(winner)
    winner.increase_bank(@bank)
    reduce_bank(@bank)
  end
end
