# frozen_string_literal: true

class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.offset(page).limit(per_page)
    json_response(MerchantSerializer.new(merchants))
  end

  def show
    merchant = Merchant.find(params[:id])
    json_response(MerchantSerializer.new(merchant))
  end
end
