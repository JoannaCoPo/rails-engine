class Api::V1::Revenue::MerchantsController < ApplicationController
  def most_revenue
    merchants = Merchant.top_revenue(params[:quantity])
    json_response(MerchantRevenueSerializer.new(merchants))
  end

  def total_revenue
    merchant = Merchant.find(params[:id])
    merchant_revenue = merchant.total_revenue
    json_response(MerchantRevenueSerializer.new(merchant_revenue))
  end
end
