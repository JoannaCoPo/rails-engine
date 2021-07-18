class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchants = Merchant.find(params[:id])
    render json: ItemSerializer.new(merchants.items)
  end
end
