RSpec.describe ExchangeRate do
  
  it 'Endpoint actually works' do
    WebMock.allow_net_connect!
    valid_uri = "https://api.nomics.com/v1/exchange-rates?\
key=#{Figaro.env.NOMICS_API_KEY}"
    expect(HTTP.get(valid_uri).status).to eq 200
  end

  describe 'fetch' do
  	before(:each) do
  		valid_response = "[{\"currency\":\"GBP\",\"rate\":\"1.37579968\",\"timestamp\":\"2021-10-23T00:00:00Z\"}]\n"
  		    stub_request(:any, /api.nomics.com/).
      to_return(body: valid_response)
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