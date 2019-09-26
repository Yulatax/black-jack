require_relative 'bank_module'
require_relative 'hand'

class User

  MAX_HAND_LENGTH = 3

  include Bank
  include Hand

  attr_reader :name
  attr_accessor :bank, :hand

  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
  end

  def display_hand(show = false)
    if self.name == 'Dealer' && !show
      puts "#{self.name}: #{hand.map { '*' }.join}, points: **"
    else
      puts "#{self.name}: #{self.cards}, points: #{self.points}"
    end
  end

  def clear_hand
    self.hand = []
  end

  def hand_limit?
    self.hand.length == MAX_HAND_LENGTH
  end
end
