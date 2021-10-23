class PagesController < ApplicationController

  def table
    @error, @data = Ticker.fetch(params[:currencies])
    @available_attributes = helpers.available_attributes
    if filter_enabled?
      @show_attributes = selected_attributes
      @data = filter_data
    else
      @show_attributes = @available_attributes
    end
  end

  def local
    return if fresh_local_page?
    @error, @price = Calculator.price_of(
      params[:crypto],
      params[:fiat])
  end

  def compare
    return if fresh_compare_page?
    @error, @comparison = Calculator.compare(
      params[:base_crypto],
      params[:comparison_crypto])
  end

private
  
  def ticker_params
    params.permit(:crypto_currencies,
      helpers.available_attributes.map(&:to_sym))
  end

  def local_params
    params.permit(:crypto, :fiat)
  end

  def compare_params
    params.permit(:base_crypto, :comparison_crypto)
  end

  def fresh_local_page?
    params[:crypto].blank?
  end

  def fresh_compare_page?
    params[:base_crypto].blank?
  end

  def filter_enabled?
    helpers.available_attributes.each do |attribute|
      return true if ticker_params[attribute] == "1"
    end
    false
  end

  #
  # Creates an array of selected attributes from check_box inputs
  # e.g. ['id', 'currency', 'markey_cap']
  #
  def selected_attributes
    selected_attributes = ticker_params.select{|k,v| v == "1" }.to_hash.keys
    selected_attributes << 'id' # always include the ID
  end

  #
  # This method takes the all-attribute data from the API's response
  # and filters down to a hash containing only the attributes selected
  # with the on-page checkboxes.
  #
  def filter_data
    @data.map do |currency|
      currency.select { |attribute,_|
        selected_attributes.include? attribute.to_s
      }
    end
  end

end