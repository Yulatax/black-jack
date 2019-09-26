# frozen_string_literal: true

require_relative 'user'

class Dealer < User
  attr_reader :actions

  def initialize
    @name = dealer_name
    @actions = dealer_actions
    super(@name)
  end

  def restore_actions
    @actions = dealer_actions
  end

  def remove_action(user_action)
    @actions.delete_if { |action| action == user_action }
  end

  private

  def dealer_name
    'Dealer'
  end

  def dealer_actions
    ['skip action', 'add card']
  end
end
