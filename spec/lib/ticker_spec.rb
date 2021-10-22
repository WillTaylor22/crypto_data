RSpec.describe Ticker do

  it 'gets data' do
    VALID_RESPONSE = "[{\"id\":\"BTC\",\"name\":\"Bitcoin\",\"price\":\"57123.28385027\"}]"

    stub_request(:any, /api.nomics.com/).
      to_return(body: VALID_RESPONSE)

    expect(Ticker.fetch({ ids: 'BTC' })).to eq([nil, JSON.parse(VALID_RESPONSE)])
  end

  it 'passes on errors' do
    stub_request(:any, /api.nomics.com/).
      to_return(status: [500, "Internal Server Error"])
    expect(Ticker.fetch({ ids: 'BTC' })).to eq(["Nomics API failed", nil])
  end

end