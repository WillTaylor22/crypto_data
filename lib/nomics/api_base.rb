class ApiBase
    API_KEY_ERROR = 'No Nomics API key'
    API_FAILED_ERROR = 'Nomics API failed'
    CONNECTION_ERROR = 'Unable to connect to Nomics API'
    BASE_URL = 'https://api.nomics.com/v1'
    UNAUTHORIZED_ERROR = 'Invalid Nomics API key'
    API_UNREADABLE_ERROR = 'Nomics Api response unreadable'

    def self.request(path, params)
      return API_KEY_ERROR, nil unless Figaro.env.NOMICS_API_KEY.present?
      query = params.to_query

      begin
        res = HTTP.get("#{BASE_URL}#{path}?key=#{Figaro.env.NOMICS_API_KEY}&#{query}")
      rescue HTTP::ConnectionError
        return CONNECTION_ERROR, nil
      end

      error = UNAUTHORIZED_ERROR if res.status == 401
      error = API_FAILED_ERROR if res.status == 500

      begin
        data = JSON.parse res.body unless error
        return error, data
      rescue JSON::ParserError
        return API_UNREADABLE_ERROR, nil
      end
    end

end