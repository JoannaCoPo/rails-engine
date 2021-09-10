class Api::V1::Items::SearchController < ApplicationController
  def find_all
    items_found = search(params)
    json_response(ItemSerializer.new(items_found))
  end

  def search(params)
    if params[:name]
      items_found = Item.search_name_descript(params[:name])
    elsif params[:min_price] || params[:max_price]
      items_found = Item.search_price( { min_price: params[:min_price], max_price: params[:max_price] } )
    end
  end
end
