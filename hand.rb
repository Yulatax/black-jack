# frozen_string_literal: true

require_relative 'deck'

module Hand
  attr_accessor :hand

  def cards
    hand.map(&:name).join(' ')
  end

  def points
    points = 0
    @hand.each do |card|
      points += card.face == 'A' ? ace_value(points, card.value) : card.value
    end
    points
  end

  private

  def ace_value(points, card_value)
    points + card_value <= 21 ? card_value : 1
  end
end
