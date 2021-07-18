require 'rails_helper'

describe "Merchant Items API", type: :request do
  describe 'happy path' do
    it "gets all items for a given merchant ID" do

      merchant_1 = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)
      item_2 = FactoryBot.create(:item, merchant_id: merchant_1.id)
      item_3 = FactoryBot.create(:item, merchant_id: merchant_1.id)

      get "/api/v1/merchants/#{merchant_1.id}/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.server_error?).to eq(false)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(3)
      expect(items[:data].first[:id].to_i).to eq(item_1.id)
      expect(items[:data].first[:attributes][:name]).to eq(item_1.name)
    end
  end
end
