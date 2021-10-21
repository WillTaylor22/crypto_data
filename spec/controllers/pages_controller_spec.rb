RSpec.describe PagesController do

	before(:each) do
		@controller = PagesController.new

		params = ActionController::Parameters.new({})
		allow(@controller).to receive(:params).and_return(params)
	end

	describe "build_ticker_params" do
		it "returns BTC only when params are blank" do
		    expect(@controller.send(:build_ticker_params)).to eq({ids: 'BTC'})
		end

		it "returns the currencies entered when params present" do
			params = ActionController::Parameters.new({ crypto_currencies: 'ETH' })
			allow(@controller).to receive(:params).and_return(params)

		    expect(@controller.send(:build_ticker_params)).to eq({ids: 'ETH'})
		end
	end

	describe "filter_enabled?" do
		it "returns false when no filters selected" do
			expect(@controller.send(:filter_enabled?)).to be false
		end

		it "returns false when filters are zero" do
			params = ActionController::Parameters.new({
				currency: "0",
				id: "0",
				status: "0",
				price: "0"
			})
			allow(@controller).to receive(:params).and_return(params)
			expect(@controller.send(:filter_enabled?)).to be false
		end

		it "returns true when filters are present" do
			params = ActionController::Parameters.new({
				currency: "1",
				id: "0",
				status: "0",
				price: "0"
			})
			allow(@controller).to receive(:params).and_return(params)
			expect(@controller.send(:filter_enabled?)).to be true
		end
	end

	describe "selected_attributes" do
		it "creates an array of the selected attributes" do
			@controller.instance_variable_set(:@data, [{
	        	"id": "BTC",
	        	"currency": "usd",
			    "status": "active",
			    "price": "57123.28385027",
			    "price_date": "2021-10-21T00:00:00Z",
			    "price_timestamp": "2021-10-21T09:33:00Z",
			    "symbol": "BTC",
			    "circulating_supply": "18849850"
	        },{
	        	"id": "ETH",
	        	"currency": "usd",
			    "status": "active",
			    "price": "57123.28385027",
			    "price_date": "2021-10-21T00:00:00Z",
			    "price_timestamp": "2021-10-21T09:33:00Z",
			    "symbol": "BTC",
			    "circulating_supply": "18849850"
	        }])

			params = ActionController::Parameters.new({
				currency: "1",
				status: "0",
				price: "0"
			})
			allow(@controller).to receive(:params).and_return(params)

			expect(@controller.send(:selected_attributes)).to eq(['currency', 'id'])
		end
	end

	describe "filter data" do
		it "selects only the requested attributes" do
	        @controller.instance_variable_set(:@data, [{
	        	"id": "BTC",
	        	"currency": "usd",
			    "status": "active",
			    "price": "57123.28385027",
			    "price_date": "2021-10-21T00:00:00Z",
			    "price_timestamp": "2021-10-21T09:33:00Z",
			    "symbol": "BTC",
			    "circulating_supply": "18849850"
	        },{
	        	"id": "ETH",
	        	"currency": "usd",
			    "status": "active",
			    "price": "57123.28385027",
			    "price_date": "2021-10-21T00:00:00Z",
			    "price_timestamp": "2021-10-21T09:33:00Z",
			    "symbol": "BTC",
			    "circulating_supply": "18849850"
	        }])

			params = ActionController::Parameters.new({
				currency: "1",
				status: "0",
				price: "0"
			})
			allow(@controller).to receive(:params).and_return(params)

			expect(@controller.send(:filter_data)).to eq([
				{id: "BTC", "currency": "usd"},
				{id: "ETH", "currency": "usd"}
			])
		end
	end

end