require 'oystercard'
describe Oystercard do
  subject(:oystercard) { described_class.new }

  it 'checks card balance' do
    expect(oystercard).to respond_to(:balance)
  end
end
