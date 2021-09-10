# frozen_string_literal: true

class Api::V1::ItemsController < ApplicationController
  def index
    all_items = Item.all
    items = Item.offset(page).limit(per_page)
    json_response(ItemSerializer.new(items))
  end

  def show
    json_response(ItemSerializer.new(item))
  end

  def create
    item = Item.create!(item_params)
    json_response(ItemSerializer.new(item), :created)
  end

  def update
    item = Item.update(params[:id], item_params)
    json_response(ItemSerializer.new(item))
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
