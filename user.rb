require_relative 'bank_module'
require_relative 'hand'

class User

  include Bank
  include Hand

  attr_reader :name
  attr_accessor :bank, :hand

  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
  end
end
