RSpec.describe Ticker do

  it 'gets data' do
    valid_response = "[{\"id\":\"BTC\",\"name\":\"Bitcoin\",\"price\":\"57123.28385027\"}]"

    stub_request(:any, /api.nomics.com/).
      to_return(body: valid_response)

    expect(Ticker.fetch({ ids: 'BTC' })).to eq([nil, JSON.parse(valid_response)])
  end

  it 'passes on errors' do
    stub_request(:any, /api.nomics.com/).
      to_return(status: [500, "Internal Server Error"])
    expect(Ticker.fetch({ ids: 'BTC' })).to eq(["Nomics API failed", nil])
  end

  describe "build_params" do
    it "returns BTC only when params are blank or nil" do
        expect(Ticker.send(:build_params, nil)).to eq({ids: 'BTC'})
        expect(Ticker.send(:build_params, "")).to eq({ids: 'BTC'})
    end

    it "returns the currencies entered when params present" do
        expect(Ticker.send(:build_params, 'ETH')).to eq({ids: 'ETH'})
    end
  end

end