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

  # it 'deducts money from card upon touch out' do
  #   expect{ journey.touch_out(oystercard, exit_station) }.to change{ oystercard.balance }.by -1
  # end

  context 'if it has minimum limit' do
    before do
      oystercard.top_up(20)
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

      it 'deducts the minimum amount when touched out having touched in.' do
        expect{ journey.touch_out(oystercard, exit_station) }.to change{ oystercard.balance }.by(-Oystercard::MIN_FARE)
      end

      it 'charges the penalty fare when touching in with an unresolved journey' do
        expect {journey.touch_in(oystercard, entry_station)}.to change { oystercard.balance}.by(-(Oystercard::MIN_FARE*6))
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
 context "Fare calculations" do
   it 'Calculates fare when touched in and touched out' do
     expect(journey.fare(entry_station, exit_station)).to eq(Oystercard::MIN_FARE)
   end
   it 'Calculates a penalty fare when the origin station is missing' do
     expect(journey.fare(nil, exit_station)).to eq(Oystercard::MIN_FARE*6)
   end
   it 'Calculates a penalty fare when the origin station is missing' do
     expect(journey.fare(entry_station, nil)).to eq(Oystercard::MIN_FARE*6)
   end
   it 'Calculates a penalty fare when the both stations are missing' do
     expect(journey.fare(nil, nil)).to eq(Oystercard::MIN_FARE*6)
   end
 end


end
