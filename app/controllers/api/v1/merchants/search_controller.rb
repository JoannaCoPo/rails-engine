class Api::V1::Merchants::SearchController < ApplicationController
  def find
    merchant_results = Merchant.search_merchant_with_query(params[:name])
    return search_error if merchant_results.empty?
    json_response(MerchantSerializer.new(merchant_results.first))
  end
end

# return the first object in the database in case-sensitive alphabetical order
# if multiple matches are found

#return the first object in the database in case-sensitive alphabetical order if
# multiple matches are found
