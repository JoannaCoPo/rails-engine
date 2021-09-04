require 'rails_helper'

describe "Merchant Items", type: :request do
  describe 'happy path' do
    it "gets all items for a given merchant ID" do
      merchant = create(:merchant)
      item = create_list(:item, 5, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(5)

      expect(items[:data].first).to have_key(:id)
      expect(items[:data].first[:id]).to be_a(String)

      expect(items[:data].first[:attributes]).to have_key(:name)
      expect(items[:data].first[:attributes][:name]).to be_a(String)

      expect(items[:data].first[:attributes]).to have_key(:description)
      expect(items[:data].first[:attributes][:description]).to be_a(String)

      expect(items[:data].first[:attributes]).to have_key(:unit_price)
      expect(items[:data].first[:attributes][:unit_price]).to be_a(Float)

      expect(items[:data].first[:attributes]).to have_key(:merchant_id)
      expect(items[:data].first[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  describe 'sad paths/edge cases' do
    it 'returns a 200 status code and an empty array if a merhcants has zero items' do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to eq([])
    end

    it 'returns a 404 status code and error message if the merchant does not exist' do
      get "/api/v1/merchants/9999999999999999/items"

      expect(response.status).to eq(404)
      expect(response.body).to match(/Couldn't find Merchant with 'id'=9999999999999999/)
    end
  end
end
