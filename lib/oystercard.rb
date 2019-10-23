class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :journeys

  MAX_LIMIT = 90
  MIN_LIMIT = 1
  MIN_FARE = 1

  def initialize(balance = 0)
    @balance = balance
    @max_limit = MAX_LIMIT
    @min_limit = MIN_LIMIT
    @entry_station = entry_station
    @exit_station = exit_station
    @journeys = {}
  end

  def top_up(amount)
    total = balance + amount
    raise 'You have reached the £90 limit' if total > @max_limit
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(station)
    raise 'Insufficient funds to touch in' if balance < @min_limit
    @entry_station = station
  end

  def touch_out(station)
    deduct(MIN_FARE)
    @exit_station = station
    journey
  end

  def journey
    @journeys.store(@entry_station, @exit_station)
    @entry_station = nil
    #journeys.map { |journey| [entry_station, exit_station] }
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
