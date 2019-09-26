# frozen_string_literal: true

require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @faces = faces_array
    @suits = suits_array
    @cards = build_deck
  end

  def show_deck
    @cards.each { |card| puts card.name }
  end

  def take_card
    @cards.pop
  end

  private

  def build_deck
    cards = []
    @faces.each do |face|
      @suits.each do |suit|
        cards << Card.new(face: face, suit: suit)
      end
    end
    cards.shuffle!
  end

  def faces_array
    %w[2 3 4 5 6 7 8 9 10 J Q K A]
  end

  def suits_array
    %w[+ <3 ^ <>]
  end
end
