require 'oystercard'
describe Oystercard do
  subject(:oystercard) { described_class.new }

  it 'checks card balance' do
    expect(oystercard).to respond_to(:balance)
  end

  it 'ensures initial balance is 0' do
    expect(oystercard.balance).to eq 0
  end

  it 'responds to top_up with 1 argument' do
    expect(oystercard).to respond_to(:top_up).with(1).argument
  end

  it 'adds money to card' do
    expect{ oystercard.top_up(1) }.to change{ oystercard.balance }.by 1
  end

  it 'raises error when more than £90 added' do
    oystercard.top_up(90)
    expect{ oystercard.top_up(1) }.to raise_error 'You have reached the £90 limit'
  end
end
