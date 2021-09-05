# frozen_string_literal: true

require 'rails_helper'

describe 'Items Requests', type: :request do
  describe 'happy path' do
    it 'gets all items with a max of 20 per page' do
      create_list(:merchant_plus_items, 33)

      get '/api/v1/items'

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.server_error?).to eq(false)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(33)

      items[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item).to have_key(:unit_price)
        expect(item[:attributes][:description]).to be_a(Float)

        expect(item[:type]).to eq('item')
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a Hash
      end
    end
  end
end
