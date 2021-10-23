class PagesController < ApplicationController

  def table
    @error, @data = Ticker.new.get(build_ticker_params)
    @available_attributes = available_attributes
    if filter_enabled?
      @show_attributes = selected_attributes
      @data = filter_data
    else
      @show_attributes = @available_attributes
    end
  end

  def local
    # # default currency to BTC to avoid long hanging requests.
    # # could add front-end error handling
    # @error, @data = TickerData.new.get({ids: local_params || 'BTC'})
    # error_exhange_rates, @data = ExchangeRates.new.get(params[:fiat])

    # # Display one of the errors if present. In the event of two errors,
    # # the root cause will be the same in this simple scenario.
    # @error ||= error_exhange_rates
  end

  def compare
    if do_comparison?
        @error, @comparison = Calculator.compare(
          params[:base_crypto],
          params[:comparison_crypto])
      end
    end
end

private
  
  def ticker_params
    params.permit(:crypto_currencies, available_attributes.map(&:to_sym))
  end

  def local_params
    params.permit(:crypto, :fiat)
  end

  def compare_params
    params.permit(:base_crypto, :comparison_crypto)
  end

  def do_comparison?
    params[:base_crypto].present?
  end

  def build_ticker_params
    # default to BTC to avoid long hanging requests.
    {
      ids: ticker_params[:crypto_currencies] || 'BTC',
    }
  end

  def filter_enabled?
    available_attributes.each do |attribute|
      return true if ticker_params[attribute] == "1"
    end
    false
  end

  #
  # Creates an array of selected attributes
  # e.g. ['id', 'currency', 'markey_cap']
  #
  def selected_attributes
    selected_attributes = ticker_params.select{|k,v| v == "1" }.to_hash.keys
    selected_attributes << 'id' # always include the ID
  end

  #
  # This method takes the data from the API's response and returns
  # a hash containing only the attributes selected
  # with the on-page checkboxes.
  #
  def filter_data
    @data.map do |currency|
      currency.select { | attribute,_|
        selected_attributes.include? attribute.to_s
      }
    end
  end

  def available_attributes
    ["currency",
    "status",
    "price",
    "price_date",
    "price_timestamp",
    "symbol",
    "circulating_supply",
    "max_supply",
    "name",
    "logo_url",
    "market_cap",
    "market_cap_dominance",
    "transparent_market_cap",
    "num_exchanges",
    "num_pairs",
    "num_pairs_unmapped",
    "first_candle",
    "first_trade",
    "first_order_book",
    "first_priced_at",
    "rank",
    "rank_delta",
    "high",
    "high_timestamp"] 
  end