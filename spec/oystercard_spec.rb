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
    oystercard.balance = Oystercard::MAX_LIMIT
    expect{ oystercard.top_up(1) }.to raise_error 'You have reached the £90 limit'
  end

  it 'deducts money from card' do
    expect{ oystercard.touch_out }.to change{ oystercard.balance }.by -1
  end

  it 'can be used to touch in' do
    expect(oystercard).to respond_to(:touch_in)
  end

  it 'is initially not in a journey' do
    expect(oystercard.in_journey?).to be false
  end

  context 'tests dependent on minimum limit' do
    before do
      expect(oystercard.balance).to be > Oystercard::MIN_LIMIT

      it 'starts journey when touched in' do
        expect{ oystercard.touch_in }.to change{ oystercard.in_journey? }.from(false).to(true)
      end

      it 'ends journey when touched out' do
        expect{ oystercard.touch_out }.to change{ oystercard.in_journey? }.from(true).to(false)
      end

      it 'deducts the minimum amount when touched out' do
        oystercard.touch_in
        expect{ oystercard.touch_out }.to change{ oystercard.balance }.by(-Oystercard::MIN_CHARGE)
      end
    end
  end



  it 'raises error when trying to touch in with less than £1' do
    oystercard.balance < Oystercard::MIN_LIMIT
    expect{ oystercard.touch_in }.to raise_error 'Insufficient funds to touch in'
  end
end
