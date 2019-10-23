require 'station'

describe Station do
  subject(:station) { described_class.new("name", "1") }

  it 'has a name' do
    expect(station.name).to eq "name"
  end

end
