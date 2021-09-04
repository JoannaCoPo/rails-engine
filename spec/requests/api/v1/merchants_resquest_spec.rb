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

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq "merchant"

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a Hash
      end
    end

    it 'returns a maximum of 20 merchants with pagination params' do
      create_list(:merchant, 33)

      get '/api/v1/merchants', params: { per_page: 20 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(20)
    end

    it 'returns a maximum of 20 merchants with unspecified pagination params' do
      create_list(:merchant, 30)

      get '/api/v1/merchants', params: { per_page: 20 }

      expect(response).to have_http_status(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(20)
    end

    it 'returns a maximum of 20 merchants per specified page' do
      create_list(:merchant, 33)

      get '/api/v1/merchants', params: { page: 2 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(13)
      expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.all[20].name)
    end

    it 'returns correct amounts for page and number per page specified' do
      create_list(:merchant, 33)

      all_merchants = Merchant.all

      get '/api/v1/merchants', params: { page: 2, per_page: 10 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(10)
      expect(merchants[:data].first[:id]).to eq(all_merchants[10].id.to_s)
      expect(merchants[:data].last[:id]).to eq(all_merchants[19].id.to_s)
    end

    it 'defaults to page 1 if page params isn less than 1' do
      create_list(:merchant, 33)

      all_merchants = Merchant.all

      get '/api/v1/merchants', params: { page: -1 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(20)
      expect(merchants[:data].first[:id]).to eq(all_merchants.first.id.to_s)
      expect(merchants[:data].last[:id]).to eq(all_merchants[19].id.to_s)
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

  # Sad Path: the user did something which didn’t cause an error but didn’t work out the way
  # they’d hoped. For example, searching for a merchant by name and getting zero results is a
  # “sad path”

  describe 'sad paths/edge cases' do
    it 'returns an empty array when no data is available' do
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(0)
      expect(merchants[:data]).to eq([])
    end
  end
end
