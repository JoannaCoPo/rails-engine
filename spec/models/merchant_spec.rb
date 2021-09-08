# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoices) }
  end

  describe 'class methods' do
    it 'returns first result that is case sensitive and alphabetical order' do
      merchant_1 = create(:merchant, name: 'Zippy and Sons')
      merchant_2 = create(:merchant, name: 'Sons, Klein, and Rempel')
      merchant_3 = create(:merchant, name: 'Willms and Sons')
      merchant_4 = create(:merchant, name: 'Applesons')

      query = Merchant.search_merchant_with_query('Sons')

      expect(query).to eq(merchant_4)
    end

    it 'returns a not found message with a 404 status if no matches' do
      merchant_1 = create(:merchant, name: 'Zippy and Sons')
      merchant_2 = create(:merchant, name: 'Sons, Klein, and Rempel')
      merchant_3 = create(:merchant, name: 'Willms and Sons')
      merchant_4 = create(:merchant, name: 'Applesons')

      query = Merchant.search_merchant_with_query('zzz')

      expect(query).to be_nil
    end
  end
end
