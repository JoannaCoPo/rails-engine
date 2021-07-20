require 'rails_helper'

describe "Merchants API", type: :request do
  describe 'happy path' do
    it "gets all merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.server_error?).to eq(false)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant|
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'returns all merchants with a maximum of 20 at a time' do
      create_list(:merchant, 33)

      get '/api/v1/merchants', params: { per_page: 20 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(20)
    end

    it 'it returns a maximum of 20 merchants per specified page' do
      create_list(:merchant, 33)

      get '/api/v1/merchants', params: { per_page: 20, page: 2 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(13)
      expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.all[20].name)
    end

    it 'can return one merchant' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to eq(id.to_s)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end

    it "get all items for a given merchant ID" do
      merchant = create(:merchant)
      items = create_list(:item, 5, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data].size).to eq(5)

      expect(merchant[:data].first).to have_key(:id)
      expect(merchant[:data].first[:id]).to be_a(String)

      expect(merchant[:data].first[:attributes]).to have_key(:name)
      expect(merchant[:data].first[:attributes][:name]).to be_a(String)

      expect(merchant[:data].first[:attributes]).to have_key(:description)
      expect(merchant[:data].first[:attributes][:description]).to be_a(String)

      expect(merchant[:data].first[:attributes]).to have_key(:unit_price)
      expect(merchant[:data].first[:attributes][:unit_price]).to be_a(Float)

      expect(merchant[:data].first[:attributes]).to have_key(:merchant_id)
      expect(merchant[:data].first[:attributes][:merchant_id]).to be_an(Integer)
    end
  end
end
