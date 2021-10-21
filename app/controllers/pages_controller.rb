class PagesController < ApplicationController

  def table
    @error, @data = TickerData.new.get(build_ticker_params)
    @available_attributes = available_attributes
  end

  def local
  end

  def compare
  end
end

private
  
  def ticker_params
    params.permit(:crypto_currencies, available_attributes.map(&:to_sym))
  end

  def build_ticker_params
    # default to BTC to avoid long hanging requests.
    {
      ids: ticker_params[:crypto_currencies] || 'BTC',
    }
  end

  def available_attributes
    ["currency",
    "id",
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