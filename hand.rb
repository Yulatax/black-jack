require_relative 'deck'

module Hand

  attr_accessor :hand

  def cards
    # if self.name == 'Dealer'
    #   hand.map { '*' }.join(' ')
    # else
    #   hand.map(&:name).join(' ')
    # end
    hand.map(&:name).join(' ')
  end

  def points
    points = 0
    @hand.each do |card|
      if card.face == 'A'
        points += ace_value(points, card.value)
      else
        points += card.value
      end
    end
    points
  end

  private

  def ace_value(points, card_value)
    points + card_value <= 21? card_value : 1
  end
end
