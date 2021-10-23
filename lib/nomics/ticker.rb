class Ticker < ApiBase

  def self.fetch(currencies)
    params = build_params(currencies)
    self.request('/currencies/ticker', params)
  end

  private

    def self.build_params(currencies)
      # default to BTC to avoid long hanging requests.
      currencies.blank? ? { ids: 'BTC' } : { ids: currencies }
    end

end