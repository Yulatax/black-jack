# frozen_string_literal: true

require_relative 'bank_module'
require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

class Game
  include Bank

  BLACKJACK = 21

  attr_reader :player, :dealer

  def initialize(player_name)
    @bank = 0
    @player = Player.new(player_name)
    @dealer = Dealer.new
  end

  def start
    @deck = Deck.new
    @player.restore_actions
    @dealer.restore_actions
    card_distribution
    bank_contribution
    @finish = false
  end

  def player_summary
    "#{@player.user_hand}"
  end

  def dealer_summary(flag)
    "#{@dealer.user_hand(flag)}"
  end

  def actions
    txt = "\n#{@player.name}, choose your action, please: \n"
    @player.actions.each_with_index do |action, index|
      txt += "#{index} - #{action}\n"
    end
    txt
  end

  def define_choice(action)
    @player.actions[action.to_i]
  end

  def user_action(action)
    return @finish = true if hand_limit_reached?

    @next = false

    case action
    when 'skip action'
      skip_action
    when 'add card'
      add_card
    when 'open cards'
      @finish = true
    else
      puts 'Choose action or enter 0 to exit'
      @next = true
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
  end

  def stop?
    @finish
  end

  def next?
    @next
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

  def user_bankrupt?
    @player.bank.zero? || @dealer.bank.zero?
  end

  def bank
    "#{@player.name} bank: #{@player.bank}\nDealer bank: #{@dealer.bank}"
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

  def skip_action
    @player.remove_action('skip action')
  end

  def add_card
    return if @player.hand.length > 2

    take_card(@player)
    @player.remove_action('add card')
  end

  def dealer_add_card
    return unless @dealer.hand.length == 2

    take_card(@dealer)
    puts "\nDealer has taken a card!\n"
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
