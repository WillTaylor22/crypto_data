RSpec.describe Calculator do
  
	describe 'compare' do
		before(:all) do
			Crypto.find_or_create_by(ticker: "BTC", name: "Bitcoin")
			Crypto.find_or_create_by(ticker: "ETH", name: "Ethereum")
		end

		before(:each) do
    	# Mock the NomicsAPI
    	btc_response = "[{\"id\":\"BTC\",\"price\":\"57123.28385027\"}]"
			stub_request(:any, /BTC/).to_return(body: btc_response)
    	eth_response = "[{\"id\":\"ETH\",\"price\":\"4078.45187161\"}]"
			stub_request(:any, /ETH/).to_return(body: eth_response)
		end

		it 'validates inputs' do
			expect(Calculator.compare(nil, 'BTC')).to eq [
				'Please provide a base crypto currency to compare with', nil]
			expect(Calculator.compare('BTC', nil)).to eq [
				'Please provide a second crypto currency to compare with', nil]
			expect(Calculator.compare('INVALID_NAME', 'BTC')).to eq [
				'The base crypto currency requested is not available', nil]
			expect(Calculator.compare('BTC', 'INVALID_NAME')).to eq [
				'The second crypto currency requested is not available', nil]
		end

		it 'passes on API errors' do
	    stub_request(:any, /api.nomics.com/).
	      to_return(status: [500, "Internal Server Error"])
			expect(Calculator.compare('BTC', 'ETH')).to eq ['Nomics API failed', nil]
		end

		it 'returns a string with the correct ratio' do
			expect(Calculator.compare('BTC', 'ETH')).to eq [
				nil, "1 BTC = 14.006119 ETH"]
		end
	end

	describe 'price of' do
		before(:all) do
			Crypto.find_or_create_by(ticker: "BTC", name: "Bitcoin")
			Fiat.find_or_create_by(ticker: "GBP")
		end

		before(:each) do
    	# Mock the NomicsAPI
    	crypto_response = "[{\"id\":\"BTC\",\"price\":\"57123.28385027\"}]"
			stub_request(:any, /BTC/).to_return(body: crypto_response)

  		exchange_rate_response = "[{\"currency\":\"GBP\",\"rate\":\"1.37579968\",\"timestamp\":\"2021-10-23T00:00:00Z\"}]\n"
	    stub_request(:any, /exchange-rates/).
	    	to_return(body: exchange_rate_response)
		end

		it 'validates inputs' do
			expect(Calculator.price_of(nil, 'GBP')).to eq [
				'Please provide a crypto currency', nil]
			expect(Calculator.price_of('BTC', nil)).to eq [
				'Please provide a fiat currency', nil]
			expect(Calculator.price_of('INVALID_CRYPTO', 'GBP')).to eq [
				'The crypto currency requested is unavailable', nil]
			expect(Calculator.price_of('BTC', 'INVALID_FIAT')).to eq [
				'The fiat currency requested is unavailable', nil]
		end

		it 'passes on API errors' do
	    stub_request(:any, /api.nomics.com/).
	      to_return(status: [500, "Internal Server Error"])
			expect(Calculator.price_of('BTC', 'GBP')).to eq ['Nomics API failed', nil]
		end

		it 'returns a string with the correct price' do
			expect(Calculator.price_of('BTC', 'GBP')).to eq [
				nil, '1 BTC = GBP 41520.06']
		end
	end

	describe 'price_crypto' do
		it 'returns an error if the coin lacks a valid price' do
			# ... not a number
    	btc_response = "[{\"id\":\"BTC\",\"price\":\"null\"}]"
			stub_request(:any, /BTC/).to_return(body: btc_response)
			expect(Calculator.send(:price_crypto, 'BTC')).to eq [
				'The price of BTC was not available', nil]

			# ...zero
    	btc_response = "[{\"id\":\"BTC\",\"price\":\"0\"}]"
			stub_request(:any, /BTC/).to_return(body: btc_response)
			expect(Calculator.send(:price_crypto, 'BTC')).to eq [
				'The price of BTC was not available', nil]

			# ...blank response from API
    	btc_response = "[]"
			stub_request(:any, /BTC/).to_return(body: btc_response)
			expect(Calculator.send(:price_crypto, 'BTC')).to eq [
				'The price of BTC was not available', nil]
		end
	end

end