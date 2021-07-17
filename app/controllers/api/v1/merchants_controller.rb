class Api::V1::MerchantsController < ApplicationController
  include Paginator

  def index
    @merchants = Merchant.offset(page).limit(per_page)
    render json: MerchantsSerializer.new(@merchants)
  end
end
