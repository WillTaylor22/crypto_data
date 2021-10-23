class ExchangeRate < ApiBase
  RATE_UNAVAILABLE = 'The currency requested is not available'

  def self.fetch(currency)
    error, response = request('/exchange-rates', {})
    return error, nil if error

    currency_data = response.find {|item| item["currency"] == currency }
    return [RATE_UNAVAILABLE, nil] unless currency_data && currency_data['rate'].present?

    [nil, currency_data['rate'].to_f]
  end

end