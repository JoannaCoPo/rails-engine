class Api::V1::MerchantsController < ApplicationController
  include Paginator

  def index
    merchants = Merchant.offset(page).limit(per_page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
end
