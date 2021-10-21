class TickerData
    API_KEY_ERROR = "No Nomics API key"
    API_FAILED_ERROR = "Nomics API Failed"
    CONNECTION_ERROR = "Unable to connect to Nomics API"
    BASE_URL = "https://api.nomics.com/v1"
    UNAUTHORIZED_ERROR = "Invalid Nomics API key"
    params = {
      ids: 'BTC,ETH,XRP',
      interval: '1d',
      convert: 'EUR',
      'per-page': '100'
    }

    def get(params)
      return API_KEY_ERROR, nil unless Figaro.env.NOMICS_API_KEY.present?
      payload = params.to_query

      begin
        res = HTTP.get("#{BASE_URL}/currencies/ticker?key=#{Figaro.env.NOMICS_API_KEY}&#{payload}")
      rescue HTTP::ConnectionError
        return CONNECTION_ERROR, nil
      end

      error = UNAUTHORIZED_ERROR if res.status == 401
      error = API_FAILED_ERROR if res.status == 500

      data = JSON.parse res.body.to_s.gsub('=>',':') unless error
      return error, data
    end
end