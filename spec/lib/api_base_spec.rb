RSpec.describe ApiBase do
  before(:all) do
    @params = {
      ids: 'BTC,ETH,XRP',
      interval: '1d',
      convert: 'EUR',
      'per-page': '100'
    }
  end

  it "Endpoint actually works" do
    WebMock.allow_net_connect!
    valid_uri = "https://api.nomics.com/v1/currencies/ticker?\
key=#{Figaro.env.NOMICS_API_KEY}&ids=BTC"


    expect(HTTP.get(valid_uri).status).to eq 200
  end

  it "gets data" do
    valid_response = "[{\"id\":\"BTC\",\"name\":\"Bitcoin\",\"price\":\"57123.28385027\"}]"

    stub_request(:any, /api.nomics.com/).
      to_return(body: valid_response)

    expect(ApiBase.request('/currencies/ticker', @params)).to eq([nil, JSON.parse(valid_response)])
  end

  it "gives an error when not connected to the internet" do
    stub_request(:any, /api.nomics.com/).to_raise(HTTP::ConnectionError)
    expect(ApiBase.request('/currencies/ticker', @params)).to eq(["Unable to connect to Nomics API", nil])
  end

  it "gives an error when no API key present" do
    allow(Figaro.env).to receive(:NOMICS_API_KEY).and_return(nil)
    expect(ApiBase.request('/currencies/ticker', @params)).to eq(["No Nomics API key", nil])
  end

  it "returns the error when the API key fails" do
    allow(Figaro.env).to receive(:NOMICS_API_KEY).and_return('123')
    expect(ApiBase.request('/currencies/ticker', @params)).to eq(["Invalid Nomics API key", nil])
  end

  it "returns the error when the API errors out" do
    stub_request(:any, /api.nomics.com/).
      to_return(status: [500, "Internal Server Error"])
    expect(ApiBase.request('/currencies/ticker', @params)).to eq(["Nomics API failed", nil])
  end

  it "returns an error when the response is not valid JSON" do
    invalid_response = ""

    stub_request(:any, /api.nomics.com/).
      to_return(body: invalid_response)

    expect(ApiBase.request('/currencies/ticker', @params)).to eq(['Nomics Api response unreadable', nil])
  end
end
