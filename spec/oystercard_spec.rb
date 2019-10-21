require 'oystercard'
describe Oystercard do
  subject(:oystercard) { described_class.new }

  it 'checks card balance' do
    expect(oystercard).to respond_to(:balance)
  end

  it 'ensures initial balance is 0' do
    expect(oystercard.balance).to eq 0
  end

  it { is_expected.to respond_to(:top_up).with(1).argument }

  it 'adds money to card' do
    expect{ oystercard.top_up(1) }.to change{ oystercard.balance }.by 1
  end

  it 'raises error when more than £90 added' do
    oystercard.balance = 90
    expect{ oystercard.top_up(1) }.to raise_error 'You have reached the £90 limit'
  end

  it 'deducts money from card' do
    expect{ oystercard.deduct(1) }.to change{ oystercard.balance }.by -1
  end

  it 'can be used to touch in' do
    expect(oystercard).to respond_to(:touch_in)
  end

  it 'is initially not in a journey' do
    expect(oystercard.in_journey?).to be false
  end

  it 'starts journey when touched in' do
    oystercard.balance = 2
    oystercard.touch_in
    expect(oystercard.in_journey?).to be true
  end

  it 'ends journey when touched out' do
    oystercard.balance = 2
    oystercard.touch_in
    oystercard.touch_out
    expect(oystercard.in_journey?).to be false
  end

  it 'raises error when trying to touch in with less than £1' do
    oystercard.balance = 0.99
    expect{ oystercard.touch_in }.to raise_error 'Insufficient funds to touch in'
  end

end
