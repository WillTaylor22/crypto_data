class Calculator

	BASE_CRYPTO_MISSING = 'Please provide a base crypto currency to compare with'
	COMPARISON_CRYPTO_MISSING = 'Please provide a second crypto currency to compare with'
	BASE_CRYPTO_UNAVAILABLE = 'The base crypto currency requested is not available'
	COMPARISON_CRYPTO_UNAVAILABLE = 'The second crypto currency requested is not available'
	CRYPTO_MISSING = 'Please provide a crypto currency'
	FIAT_MISSING = 'Please provide a fiat currency'
	CRYPTO_UNAVAILABLE = 'The crypto currency requested is unavailable'
	FIAT_UNAVAILABLE = 'The fiat currency requested is unavailable'

	def self.PRICE_UNAVAILABLE(crypto)
		"The price of #{crypto} was not available"
	end

	#
	# Gets the value of one crypto in multiples
	# of the other crypto. Inputs should be crypto
	# tickers (e.g. BTC)
	#
	# Return format is [error, string]
	#
	def self.compare(base_crypto, comparison_crypto)
		# validate inputs
		return BASE_CRYPTO_MISSING, nil if base_crypto.blank?
		return COMPARISON_CRYPTO_MISSING, nil if comparison_crypto.blank?
		return BASE_CRYPTO_UNAVAILABLE, nil if Crypto.find_by_ticker(base_crypto).blank?
		return COMPARISON_CRYPTO_UNAVAILABLE, nil if Crypto.find_by_ticker(comparison_crypto).blank?

		# get data for each coin
		# must make separate requests as the API does not respect order of id inputs.
		error, base_price = price_crypto(base_crypto)
		return error, nil if error

		error, comparison_price = price_crypto(comparison_crypto)
		return error, nil if error

		ratio = (base_price/comparison_price).round(6)

		return nil, comparison_string_for(base_crypto, comparison_crypto, ratio)
	end

	#
	# Gets price of a crypto currency, as specified by their ticker
	# (e.g. BTC)in a given fiat currency, as specified by the abbreviated
	# name (e.g. USD)
	#
	# Return format is [error, string]
	#
	def self.price_of(crypto, fiat)
		# validate inputs
		return CRYPTO_MISSING, nil if crypto.blank?
		return FIAT_MISSING, nil if fiat.blank?
		return CRYPTO_UNAVAILABLE, nil if Crypto.find_by_ticker(crypto).blank?
		return FIAT_UNAVAILABLE, nil if Fiat.find_by_ticker(fiat).blank?

		# get data for crypto and exhange rates
		error, usd_price = price_crypto(crypto)
		return error, nil if error

		error, rate = ExchangeRate.fetch(fiat)
		return error, nil if error

		local_price = (usd_price / rate).round(2)

		return nil, price_string_for(crypto, fiat, local_price)
	end

	private

		#
		# Gets the price of a particular crypto currency
		# and handles errors
		#
		def self.price_crypto(crypto)
			error, crypto_data = Ticker.fetch({ ids: crypto })
			return error, nil if error 

			return PRICE_UNAVAILABLE(crypto), nil if invalid_price?(crypto_data)
			price = crypto_data[0]['price'].to_f
			[nil, price]
		end

		def self.invalid_price?(data)
			return true if data.blank?
			price = data[0]['price'].to_f
			return price.blank? || price.to_f == 0
		end

		def self.comparison_string_for(base_crypto, comparison_crypto, ratio)
			"1 #{base_crypto} = #{ratio} #{comparison_crypto}"
		end

		def self.price_string_for(crypto, fiat, local_price)
			"1 #{crypto} = #{fiat} #{local_price}"
		end
end