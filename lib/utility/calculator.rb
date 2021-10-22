class Calculator

	BASE_CRYPTO_MISSING = 'Please provide a base crypto currency to compare with'
	COMPARISON_CRYPTO_MISSING = 'Please provide a second crypto currency to compare with'
	BASE_CRYPTO_UNAVAILABLE = 'The base crypto currency requested is not available'
	COMPARISON_CRYPTO_UNAVAILABLE = 'The second crypto currency requested is not available'

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
		error, base_data = Ticker.fetch({ ids: base_crypto })
		return error, nil if error 

		base_price = base_data[0]['price'].to_f
		return PRICE_UNAVAILABLE(base_crypto), nil if invalid_price?(base_price)

		error, comparison_data = Ticker.fetch({ ids: comparison_crypto })
		return error, nil if error 

		comparison_price = comparison_data[0]['price'].to_f
		return PRICE_UNAVAILABLE(comparison_crypto), nil if invalid_price?(comparison_price)


		ratio = (base_price/comparison_price).round(6)

		return nil, comparison_string_for(base_crypto, comparison_crypto, ratio)
	end

	def self.invalid_price?(price)
		return price.blank? || price.to_f == 0
	end

	def self.comparison_string_for(base_crypto, comparison_crypto, ratio)
		"1 #{base_crypto} = #{ratio} #{comparison_crypto}"
	end

	#
	# Gets price of a crypto currency, as specified by their ticker
	# (e.g. BTC)in a given fiat currency, as specified by the abbreviated
	# name (e.g. USD)
	#
	# Return format is [error, string]
	#
	def price_of(crypto, fiat)
		# validate inputs
		# get data for each coin
		# get exchange rates
		# calculate price
		# format string
	end

end