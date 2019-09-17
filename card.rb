class Card
  attr_reader :name, :value

  def initialize(args = {})
    @face = args[:face]
    @suit = args[:suit]
    @name = create_name
    @value = set_value
  end

  private

  def create_name
    @face + @suit
  end

  def set_value
    return 10 if ['J', 'Q', 'K'].include?(@face)
    return 11 if @face == 'A'
    @face
  end
end
