class Oystercard

  attr_accessor :balance

  MAX_LIMIT = 90
  MIN_LIMIT = 1
  MIN_FARE = 1

  def initialize(balance = 0)
    @balance = balance
    @in_journey = false
    @max_limit = MAX_LIMIT
    @min_limit = MIN_LIMIT
  end

  def top_up(amount)
    total = balance + amount
    raise 'You have reached the £90 limit' if total > @max_limit
    @balance += amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    raise 'Insufficient funds to touch in' if balance < @min_limit
    @in_journey = true
  end

  def touch_out
    deduct(MIN_FARE)
    @in_journey = false
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
