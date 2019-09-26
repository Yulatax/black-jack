require_relative 'user'

class Player < User

  attr_reader :actions

  def initialize(name = 'Player')
    @name = name
    @actions = player_actions
    super(name)
  end

  def remove_action(user_action)
    @actions.delete_if { |action| action == user_action}
  end

  def restore_actions
    @actions = player_actions
  end

  private

  def player_actions
    ['skip action', 'add card', 'open cards']
  end
end
