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
    end

    it 'can create a new item with valid attributes' do
      merchant = create(:merchant)
      item_params = {
                      "name": "Create Item",
                      "description": "A very useful item, you should buy it.",
                      "unit_price": 17.99,
                      "merchant_id": "#{merchant.id}"
                      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(response).to have_http_status(201)
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id].to_i)
    end

    it 'updates and item and returns 202 status with valid attributes' do
      id = create(:item).id
      previous_description = Item.last.description
      item_params = { description: "Cool new thing" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find(id)

      expect(response).to be_successful
      expect(item.description).to_not eq(previous_description)
      expect(item.description).to eq("Cool new thing")
    end

    describe 'sad paths/edge cases' do
      it 'returns an empty array when no data is available' do
        get '/api/v1/items'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(0)
        expect(items[:data]).to eq([])
      end

      it 'returns an error if any attribute is missing' do
        merchant = create(:merchant)
        item_params = ({
                        "name": "Create Item",
                        "unit_price": 17.99,
                        "merchant_id": "#{merchant.id}"
                        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

        expect(response).to have_http_status(422) #unprocessable entity
        expect(response.body).to match(/Validation failed: Description can't be blank/)
      end

      it 'ignores any attributes sent by the user which are not allowed' do
        merchant = create(:merchant)
        item_params = ({
                        "name": "Create Item",
                        "description": "A very useful item, you should buy it.",
                        "unit_price": 17.99,
                        "extra_param": "Going Rogue",
                        "merchant_id": "#{merchant.id}"
                        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).to be_a(Hash)
        expect(item[:data][:id]).to eq(merchant.items.last.id.to_s)
        expect(item[:data]).not_to have_key(:extra_param)
      end
    end
  end
end
