# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        merchants = Merchant.offset(page).limit(per_page)
        # render json: MerchantSerializer.new(merchants)
        json_response(MerchantSerializer.new(merchants))
      end

      def show
        merchant = Merchant.find(params[:id])
        json_response(MerchantSerializer.new(merchant))
      end
    end
  end
end
