# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        items = Item.all
        render json: ItemSerializer.new(items)
      end
    end
  end
end
