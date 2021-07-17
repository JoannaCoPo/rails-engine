require 'rails_helper'

describe "Merchants API", type: :request do
  describe 'happy path' do
    it "gets all merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful
    end
  end
end
