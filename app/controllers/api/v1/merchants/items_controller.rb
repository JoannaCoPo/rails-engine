# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          merchants = Merchant.find(params[:id])
          json_response(ItemSerializer.new(merchants.items))
        end
      end
    end
  end
end
