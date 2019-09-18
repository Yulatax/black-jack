module Bank

  attr_accessor :bank

  def increase_bank(sum)
    @bank += sum
  end

  def reduce_bank(sum)
    @bank -= sum if @bank >= sum
  end
end
