RSpec.describe ExchangeRate do
  
  it 'Endpoint actually works' do
    WebMock.allow_net_connect!
    VALID_URI = "https://api.nomics.com/v1/exchange-rates?\
key=#{Figaro.env.NOMICS_API_KEY}"
    expect(HTTP.get(VALID_URI).status).to eq 200
  end

  describe 'fetch' do
  	before(:each) do
  		VALID_RESPONSE = "[{\"currency\":\"GBP\",\"rate\":\"1.37579968\",\"timestamp\":\"2021-10-23T00:00:00Z\"}]\n"
  		    stub_request(:any, /api.nomics.com/).
      to_return(body: VALID_RESPONSE)
  	end

	  it 'returns an error when an invalid rate is requested' do
	  	expect(ExchangeRate.fetch('UNAVAILABLE_FIAT')).to eq [
	  	'The currency requested is not available', nil]
	  end

		it 'returns the exhange rate requested' do
			expect(ExchangeRate.fetch('GBP')).to eq [
				nil, 1.37579968]
		end
	end
end