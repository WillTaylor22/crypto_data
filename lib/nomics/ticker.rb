class Ticker < ApiBase

  def self.fetch(params)
    self.request('/currencies/ticker', params)
  end

end