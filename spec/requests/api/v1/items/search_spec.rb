# frozen_string_literal: true

require 'rails_helper'

describe 'Items Find All Search', type: :request do
  describe 'happy path' do
    it 'finds all items based on search criteria' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      item_1 = create(:item, name: 'Useful Item', merchant: merchant_1)
      item_2 = create(:item, name: 'Household thing', description: 'it is useful', merchant: merchant_1)
      # do I want this to show up? re description
      item_3 = create(:item, name: 'Utentil of usefullness', merchant: merchant_2)
      # should not show up
      item_4 = create(:item, name: 'Mediocre item', merchant: merchant_2)

      get "/api/v1/items/find_all/", params: { name: 'useful'}

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      items = JSON.parse(response.body, symbolize_names: true)
      item1 = items[:data].first
      item2 = items[:data].second

      expect(items[:data]).to be_an(Array)
      expect(item1[:attributes][:name]).to eq(item_1.name)
      expect(item2[:attributes][:name]).to eq(item_3.name)
    end
  end

  describe 'sad paths/edge cases' do
    it '' do

    end
  end
end
