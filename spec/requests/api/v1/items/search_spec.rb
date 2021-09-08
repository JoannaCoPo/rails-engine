# frozen_string_literal: true

require 'rails_helper'

describe 'Items Find All Search', type: :request do
  describe 'happy path' do
    xit 'finds all items based on name or description' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      item_1 = create(:item, name: 'Useful Item', merchant: merchant_1)
      item_2 = create(:item, name: 'Household thing', description: 'it is useful', merchant: merchant_1)
      item_3 = create(:item, name: 'Utensil of usefullness', merchant: merchant_2) #FIX THIS
      # should not show up
      item_4 = create(:item, name: 'Mediocre item', merchant: merchant_2)

      get "/api/v1/items/find_all/", params: { name: 'useful'}

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      items = JSON.parse(response.body, symbolize_names: true)
      item1 = items[:data].first
      item2 = items[:data].second

      expect(items[:data]).to be_an(Array)
      expect(items[:data].length).to eq(3) # FIX THIS
      expect(item1[:attributes][:name]).to eq(item_1.name)
      expect(item2[:attributes][:name]).to eq(item_2.name)
      expect(item2[:attributes][:name]).to eq(item_3.name)
    end

    it 'query as min price and returns all items with a price equal to or greater' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      item_1 = create(:item, unit_price: 26.00, merchant: merchant_1)
      item_2 = create(:item, unit_price: 100.00, description: 100.00, merchant: merchant_1)
      item_3 = create(:item, unit_price: 47.98, merchant: merchant_2)
      # should not show up
      item_4 = create(:item, unit_price: 24.00, merchant: merchant_2)

      get "/api/v1/items/find_all/", params: { min_price: 25.00}

      expect(response).to have_http_status(200)

      items = JSON.parse(response.body, symbolize_names: true)

      item1 = items[:data].first
      item2 = items[:data].second
      item3 = items[:data].third

      expect(items[:data]).to be_an(Array)
      expect(items[:data].length).to eq(3)
      expect(item1[:attributes][:name]).to eq(item_1.name)
      expect(item2[:attributes][:name]).to eq(item_2.name)
      expect(item3[:attributes][:name]).to eq(item_3.name)
    end
  end

  describe 'sad paths/edge cases' do
    it 'returns a 200 status code and empty array with no matches' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      get "/api/v1/items/find_all/", params: { name: 'useful'}

      expect(response).to have_http_status(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an(Array)
      expect(items[:data]).to be_empty
    end
  end
end


# allow the user to send one or more price-related query parameters, applicable to items only:
#   min_price=4.99 should look for anything with a price equal to or greater than $4.99
#   max_price=99.99 should look for anything with a price less than or equal to $99.99
#   both min_price and max_price can be sent
# for items, the user will send EITHER the name parameter OR either/both of the price parameters
#   users should get an error if name and either/both of the price parameters are sent
