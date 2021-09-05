# frozen_string_literal: true

class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchants = Merchant.find(params[:id])
    json_response(ItemSerializer.new(merchants.items))
  end
end
