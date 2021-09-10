class Api::V1::Merchants::SearchController < ApplicationController
  def find
    merchant_results = Merchant.search_merchant_with_query(params[:name])
    return no_match_error if merchant_results.nil?
    json_response(MerchantSerializer.new(merchant_results))
  end
end
