# frozen_string_literal: true

class Api::V1::ItemsController < ApplicationController
  def index
    all_items = Item.all
    items = Item.offset(page).limit(per_page)
    json_response(ItemSerializer.new(items))
  end
end
