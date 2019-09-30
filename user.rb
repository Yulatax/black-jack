# frozen_string_literal: true

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

  def user_hand(flag = false)
    if name == 'Dealer' && !flag
      "#{name}: #{hand.map { '*' }.join}, points: **"
    else
      "#{name}: #{cards}, points: #{points}"
    end
  end

  def clear_hand
    self.hand = []
  end

  def hand_limit?
    hand.length == MAX_HAND_LENGTH
  end
end
