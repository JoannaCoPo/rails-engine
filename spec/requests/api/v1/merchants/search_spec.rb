# frozen_string_literal: true

require 'rails_helper'

describe 'Merchants Search', type: :request do
  describe 'happy path' do
    it 'returns the first merchant case-insentivie based on search criteria' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')
      merchant_3 = create(:merchant, name: 'Willms and Sons')

      # get "/api/v1/merchants/find/", params: { name: 'emPe'}
      get "/api/v1/merchants/find/", params: { name: 'sons'}


      expect(response).to be_successful
      expect(response.status).to eq(200)

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(search_result).to be_a(Hash)
      expect(search_result.count).to eq(1)
      expect(search_result[:data][:attributes]).to have_key(:name)
      expect(search_result[:data][:id]).to eq(merchant_2.id.to_s)
    end
  end

  describe 'sad paths/edge cases' do
    it 'returns an empty json response and 404 status code if no match' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')
      merchant_3 = create(:merchant, name: 'Willms and Sons')

      get "/api/v1/merchants/find/", params: { name: 'zzz'}

      expect(response.status).to eq(404)

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(search_result).to be_a(Hash)
      expect(search_result).to have_key(:error)
    end
  end
end
