RSpec.describe TickerData do
  VALID_RESPONSE = '[{\"id\":\"BTC\",\"currency\":\"BTC\",\"symbol\":\"BTC\",\"name\":\"Bitcoin\",\"logo_url\":\"https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/btc.svg\",\"status\":\"active\",\"price\":\"57123.28385027\",\"price_date\":\"2021-10-21T00:00:00Z\",\"price_timestamp\":\"2021-10-21T09:33:00Z\",\"circulating_supply\":\"18849850\",\"max_supply\":\"21000000\",\"market_cap\":\"1076765332085\",\"market_cap_dominance\":\"0.4261\",\"num_exchanges\":\"393\",\"num_pairs\":\"66771\",\"num_pairs_unmapped\":\"5173\",\"first_candle\":\"2011-08-18T00:00:00Z\",\"first_trade\":\"2011-08-18T00:00:00Z\",\"first_order_book\":\"2017-01-06T00:00:00Z\",\"rank\":\"1\",\"rank_delta\":\"0\",\"high\":\"57123.28385027\",\"high_timestamp\":\"2021-10-21T00:00:00Z\",\"1d\":{\"volume\":\"58661640645.36\",\"price_change\":\"1940.43378260\",\"price_change_pct\":\"0.0352\",\"volume_change\":\"12493951506.51\",\"volume_change_pct\":\"0.2706\",\"market_cap_change\":\"36626936581.98\",\"market_cap_change_pct\":\"0.0352\"},\"30d\":{\"volume\":\"1297279131686.00\",\"price_change\":\"22292.56424653\",\"price_change_pct\":\"0.6400\",\"volume_change\":\"-21047837333.01\",\"volume_change_pct\":\"-0.0160\",\"market_cap_change\":\"421177173863.46\",\"market_cap_change_pct\":\"0.6424\"}},{\"id\":\"ETH\",\"currency\":\"ETH\",\"symbol\":\"ETH\",\"name\":\"Ethereum\",\"logo_url\":\"https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/eth.svg\",\"status\":\"active\",\"price\":\"3642.18205359\",\"price_date\":\"2021-10-21T00:00:00Z\",\"price_timestamp\":\"2021-10-21T09:33:00Z\",\"circulating_supply\":\"118015288\",\"market_cap\":\"429833162405\",\"market_cap_dominance\":\"0.1701\",\"num_exchanges\":\"418\",\"num_pairs\":\"52827\",\"num_pairs_unmapped\":\"49115\",\"first_candle\":\"2015-08-07T00:00:00Z\",\"first_trade\":\"2015-08-07T00:00:00Z\",\"first_order_book\":\"2018-08-29T00:00:00Z\",\"rank\":\"2\",\"rank_delta\":\"0\",\"high\":\"3642.18205359\",\"high_timestamp\":\"2021-10-21T00:00:00Z\",\"1d\":{\"volume\":\"33053509452.41\",\"price_change\":\"312.44577766\",\"price_change_pct\":\"0.0938\",\"volume_change\":\"12332675636.19\",\"volume_change_pct\":\"0.5952\",\"market_cap_change\":\"36918383429.94\",\"market_cap_change_pct\":\"0.0940\"},\"30d\":{\"volume\":\"829237448545.11\",\"price_change\":\"1278.50736640\",\"price_change_pct\":\"0.5409\",\"volume_change\":\"-209968095413.38\",\"volume_change_pct\":\"-0.2020\",\"market_cap_change\":\"151834457766.81\",\"market_cap_change_pct\":\"0.5462\"}},{\"id\":\"XRP\",\"currency\":\"XRP\",\"symbol\":\"XRP\",\"name\":\"XRP\",\"logo_url\":\"https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/XRP.svg\",\"status\":\"active\",\"price\":\"0.98730915\",\"price_date\":\"2021-10-21T00:00:00Z\",\"price_timestamp\":\"2021-10-21T09:33:00Z\",\"circulating_supply\":\"46946349017\",\"max_supply\":\"100000000000\",\"market_cap\":\"46350559962\",\"market_cap_dominance\":\"0.0183\",\"num_exchanges\":\"261\",\"num_pairs\":\"1799\",\"num_pairs_unmapped\":\"55\",\"first_candle\":\"2013-05-09T00:00:00Z\",\"first_trade\":\"2013-05-09T00:00:00Z\",\"first_order_book\":\"2018-08-29T00:00:00Z\",\"rank\":\"8\",\"rank_delta\":\"-1\",\"high\":\"2.28924432\",\"high_timestamp\":\"2018-01-07T00:00:00Z\",\"1d\":{\"volume\":\"3137846103.65\",\"price_change\":\"0.035714446\",\"price_change_pct\":\"0.0375\",\"volume_change\":\"886048052.96\",\"volume_change_pct\":\"0.3935\",\"market_cap_change\":\"1741594107.00\",\"market_cap_change_pct\":\"0.0390\"},\"30d\":{\"volume\":\"103637181643.58\",\"price_change\":\"0.24047305\",\"price_change_pct\":\"0.3220\",\"volume_change\":\"-47181485947.23\",\"volume_change_pct\":\"-0.3128\",\"market_cap_change\":\"11531388727.52\",\"market_cap_change_pct\":\"0.3312\"}}]\n'

  before(:all) do
    WebMock.allow_net_connect!
    @params = {
      ids: 'BTC,ETH,XRP',
      interval: '1d',
      convert: 'EUR',
      'per-page': '100'
    }
  end

  before(:each) do
    @ticker_data = TickerData.new
  end

  it "gets data" do
    VALID_RESPONSE = JSON.parse "[{\"id\":\"BTC\",\"name\":\"Bitcoin\",\"price\":\"57123.28385027\"}]"

    stub_request(:any, /api.nomics.com/).
      to_return(body: VALID_RESPONSE.to_s)

    expect(@ticker_data.get(@params)).to eq([nil, VALID_RESPONSE])
  end

  it "gives an error when not connected to the internet" do
    stub_request(:any, /api.nomics.com/).to_raise(HTTP::ConnectionError)
    expect(@ticker_data.get(@params)).to eq(["Unable to connect to Nomics API", nil])
  end

  it "gives an error when no API key present" do
    allow(Figaro.env).to receive(:NOMICS_API_KEY).and_return(nil)
    expect(@ticker_data.get(@params)).to eq(["No Nomics API key", nil])
  end

  it "returns the error when the API key fails" do
    allow(Figaro.env).to receive(:NOMICS_API_KEY).and_return('123')
    expect(@ticker_data.get(@params)).to eq(["Invalid Nomics API key", nil])
  end

  it "returns the error when the API errors out" do
    stub_request(:any, /api.nomics.com/).
      to_return(status: [500, "Internal Server Error"])
    expect(@ticker_data.get(@params)).to eq(["Nomics API Failed", nil])
  end
end
