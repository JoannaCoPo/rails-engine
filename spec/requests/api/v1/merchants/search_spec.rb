# frozen_string_literal: true

require 'rails_helper'

describe 'Merchants Search', type: :request do
  describe 'happy path' do
    it 'find one merchant based on search criteria' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Jones')
      merchant_3 = create(:merchant, name: 'Willms and Sons')

      get "/api/v1/merchants/find/", params: { name: 'emPe'}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(search_result).to be_a(Hash)
      expect(search_result[:data][:id]).to eq(merchant_2.id.to_s)
    end
  end
end