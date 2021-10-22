RSpec.describe Calculator, focus: true do
  
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

		it 'returns an error if either coin lacks a valid price' do
			# Base crypto invalid price
    	btc_response = "[{\"id\":\"BTC\",\"price\":\"null\"}]"
			stub_request(:any, /BTC/).to_return(body: btc_response)

			# ... not a number
			expect(Calculator.compare('BTC', 'ETH')).to eq [
				'The price of BTC was not available', nil]

			# ...zero
    	eth_response = "[{\"id\":\"BTC\",\"price\":\"0\"}]"
			expect(Calculator.compare('BTC', 'ETH')).to eq [
				'The price of BTC was not available', nil]

			# Comaparison crypto invalid price
    	btc_response = "[{\"id\":\"BTC\",\"price\":\"57123.28385027\"}]"
			stub_request(:any, /BTC/).to_return(body: btc_response)
    	eth_response = "[{\"id\":\"ETH\",\"price\":\"not available\"}]"
			stub_request(:any, /ETH/).to_return(body: eth_response)

			# ... not a number
			expect(Calculator.compare('BTC', 'ETH')).to eq [
				'The price of ETH was not available', nil]

			# ... zero
    	eth_response = "[{\"id\":\"ETH\",\"price\":\"0.00\"}]"
			stub_request(:any, /ETH/).to_return(body: eth_response)

			expect(Calculator.compare('BTC', 'ETH')).to eq [
				'The price of ETH was not available', nil]
		end

		it 'returns a string with the correct ratio' do
			expect(Calculator.compare('BTC', 'ETH')).to eq [
				nil, "1 BTC = 14.006119 ETH"]
		end
	end

end