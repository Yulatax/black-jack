require_relative 'user'

class Dealer < User

  def initialize
    @name = dealer_name
    super(@name)
  end

  private

  def dealer_name
    'Dealer'
  end
end
