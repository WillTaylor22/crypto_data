RSpec.describe ExchangeRates do
  
  before(:all) do
    	WebMock.allow_net_connect!
	end

	it "returns the exhange rate requested" do
		ExchangeRates.get('usd')
	end
end