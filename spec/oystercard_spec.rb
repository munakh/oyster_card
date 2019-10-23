require 'oystercard'
describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:journey) { double :journey }

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

  it 'is initially not in a journey' do
    expect(oystercard.in_journey?).to be false
  end

  it 'can be used to touch in' do
    expect(oystercard).to respond_to(:touch_in)
  end

  it 'deducts money from card upon touch out' do
    expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by -1
  end

  context 'if it has minimum limit' do
    before do
      oystercard.top_up(Oystercard::MIN_LIMIT)
    end

    it 'starts journey when touched in' do
      expect{ oystercard.touch_in(entry_station) }.to change{ oystercard.in_journey? }.from(false).to(true)
    end

    context 'and when in journey' do
      before do
        oystercard.touch_in(entry_station)
      end

      it 'ends journey when touched out' do
        expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.in_journey? }.from(true).to(false)
      end

      it 'deducts the minimum amount when touched out' do
        expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by(-Oystercard::MIN_FARE)
      end

      it 'stores the entry station' do
        expect(oystercard.entry_station).to eq entry_station
      end

      it 'stores the exit station' do
        oystercard.touch_out(exit_station)
        expect(oystercard.exit_station).to eq exit_station
      end

      it 'stores a journey' do
        oystercard.touch_out(exit_station)
        expect(subject.journeys).to eq({entry_station => exit_station})
      end
    end
  end

  it 'raises error when trying to touch in with less than £1' do
    oystercard.balance < Oystercard::MIN_LIMIT
    expect{ oystercard.touch_in(entry_station) }.to raise_error 'Insufficient funds to touch in'
  end

  it 'has an empty list of journeys by default' do
    expect(oystercard.journeys).to be_empty
  end
end
