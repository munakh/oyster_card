class Oystercard

  attr_reader :balance
  INITIAL_BALANCE = 0

  def initialize(balance = INITIAL_BALANCE)
    @balance = balance
  end

  def top_up(amount)
    @balance += amount
  end
end
