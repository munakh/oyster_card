require 'journey'

class Oystercard

  attr_reader :balance

  MAX_LIMIT = 90
  MIN_LIMIT = 1
  MIN_FARE = 1

  def initialize(balance = 0)
    @balance = balance
    @max_limit = MAX_LIMIT
    @min_limit = MIN_LIMIT
  end

  def top_up(amount)
    total = balance + amount
    raise 'You have reached the £90 limit' if total > @max_limit
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end
end
