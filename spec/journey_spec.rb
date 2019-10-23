require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let(:oystercard) { Oystercard.new }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  it 'is initially not in a journey' do
    expect(journey.in_journey?).to be false
  end

  it 'can be used to touch in' do
    expect(journey).to respond_to(:touch_in)
  end

  it 'deducts money from card upon touch out' do
    expect{ journey.touch_out(oystercard, exit_station) }.to change{ oystercard.balance }.by -1
  end

  context 'if it has minimum limit' do
    before do
      oystercard.top_up(Oystercard::MIN_LIMIT)
    end

    it 'starts journey when touched in' do
      expect{ journey.touch_in(oystercard, entry_station) }.to change{ journey.in_journey? }.from(false).to(true)
    end

    context 'and when in journey' do
      before do
        journey.touch_in(oystercard, entry_station)
      end

      it 'ends journey when touched out' do
        expect{ journey.touch_out(oystercard, exit_station) }.to change{ journey.in_journey? }.from(true).to(false)
      end

      it 'deducts the minimum amount when touched out' do
        expect{ journey.touch_out(oystercard, exit_station) }.to change{ oystercard.balance }.by(-Oystercard::MIN_FARE)
      end

      it 'stores the entry station' do
        expect(journey.entry_station).to eq entry_station
      end

      it 'stores the exit station' do
        journey.touch_out(oystercard, exit_station)
        expect(journey.exit_station).to eq exit_station
      end

      it 'stores a journey' do
        journey.touch_out(oystercard, exit_station)
        expect(journey.journeys).to eq({entry_station => exit_station})
      end
    end
  end


end
