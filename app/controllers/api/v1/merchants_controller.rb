class Api::V1::MerchantsController < ApplicationController
  MERCHANTS_PER_PAGE = 20

  def index
    @page = params.fetch(:page, 1).to_i
    @merchants = Merchant.offset(@page * MERCHANTS_PER_PAGE).limit(MERCHANTS_PER_PAGE)
     # ^ page num * merchants per page
    # merchants = Merchant.limit(per_page).offset(page)
    render json: MerchantSerializer.new(@merchants)
  end

  private


end
