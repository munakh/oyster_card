class Oystercard

  attr_accessor :balance

  def initialize(balance = 0)
    @balance = balance
    @limit = 90
  end

  def top_up(amount)
    raise 'You have reached the £90 limit' if (@balance + amount) >= @limit
    @balance += amount
  end
end
