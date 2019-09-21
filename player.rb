require_relative 'user'

class Player < User

  def initialize(name = 'Player')
    @name = name
    super(name)
  end
end
