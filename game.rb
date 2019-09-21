require_relative 'bank_module'
require_relative 'deck'

class Game
  include Bank

  def initialize(args = {})
    @bank = 0
    @player = args[:player]
    @dealer = args[:dealer]
    @deck = Deck.new
    @deck.build_deck
  end

  def run
    card_distribution
    display_cards
    bank_contribution
    user_action
  end

  private

  def card_distribution
    2.times { take_card(@player) }
    2.times { take_card(@dealer) }
  end

  def display_cards
    puts "Your cards: #{@player.cards}, points: #{@player.points}"
    puts "Dealer's cards: #{@dealer.cards}, points: #{@dealer.points}"
  end

  def bank_contribution
    contribute_to_game_bank(@player, 10)
    contribute_to_game_bank(@dealer, 10)
  end

  def user_action
    choice = actions.to_i
    break if choice.zero?

    case choice
    when 1
      puts 'Dealer plays'
    when 2
      puts 'Take a card'
    when 3
      puts 'Open cards'
    else
      puts 'Choose action or enter 0 to exit'
    end
  end

  def actions
    puts "\nYour action now:
    1 - skip action
    2 - add card
    3 - open cards
    0 - exit
    \n"
    gets.chomp
  end

  def take_card(user)
    user.hand << @deck.take_card
  end

  def contribute_to_game_bank(user, sum)
    user.reduce_bank(sum)
    self.increase_bank(sum)
  end
end
