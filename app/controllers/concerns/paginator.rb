# frozen_string_literal: true

module Paginator
  MERCHANTS_PER_PAGE = 20

  def per_page
    params.fetch(:per_page, MERCHANTS_PER_PAGE).to_i
  end

  def page
    page = [params.fetch(:page, 1).to_i, 1].max
    # page = params.fetch(:page, 1).to_i
    (page - 1) * per_page
  end
  # ^ page num * merchants per page
  # merchants = Merchant.limit(per_page).offset(page)
end
