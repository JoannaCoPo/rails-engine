# frozen_string_literal: true

require 'rails_helper'

describe 'Items Requests', type: :request do
  describe 'happy path' do
    it 'gets all items with a max of 20 per page' do
      create(:merchant_plus_items, items_count: 33)

      get '/api/v1/items'

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.server_error?).to eq(false)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)

      items[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:type]).to eq('item')
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a Hash
      end

      it 'can create a new item' do
        item_params = ({
                        "name": "Create Item",
                        "description": "A very useful item, you should buy it.",
                        "unit_price": 17.99,
                        "merchant_id": 11
                        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
        created_item = Item.last

        expect(response).to be_successful
        expect(created_item.name).to eq(item_params[:name])
        expect(created_item.description).to eq(item_params[:description])
        expect(created_item.unit_price).to eq(item_params[:unit_price])
        expect(created_item.merchant_id).to eq(item_params[:merchant_id])
      end
    end

    describe 'sad paths/edge cases' do
      it 'returns an empty array when no data is available' do
        get '/api/v1/items'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(0)
        expect(items[:data]).to eq([])
      end
    end
  end
end
