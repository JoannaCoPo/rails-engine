class Api::V1::Items::SearchController < ApplicationController
  def find_all
    all_items_found = Item.search_with_query(params[:name])
    json_response(ItemSerializer.new(all_items_found))
  end
end
