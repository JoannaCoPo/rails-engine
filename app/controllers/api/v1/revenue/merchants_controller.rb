class Api::V1::Revenue::MerchantsController < ApplicationController
  def most_revenue
    merchants = Merchant.top_revenue(params[:quantity])
    json_response(MerchantRevenueSerializer.new(merchants))
  end
end
