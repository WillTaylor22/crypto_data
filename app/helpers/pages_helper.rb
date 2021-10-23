module PagesHelper

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

end
