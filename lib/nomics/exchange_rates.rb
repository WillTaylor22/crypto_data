class ExchangeRates < ApiBase

  def get(currency)
    error, response = request('/exchange-rates', {})
  end

end