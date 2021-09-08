# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'search_name_descript' do
    it 'returns any matching items by name and/or description' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      item_1 = create(:item, name: 'Useful Item', merchant: merchant_1)
      item_2 = create(:item, name: 'Household thing', description: 'it is useful', merchant: merchant_1)
      item_3 = create(:item, name: 'Utensil of usefullness', merchant: merchant_2)
      # should not show up
      item_4 = create(:item, name: 'Mediocre item', merchant: merchant_2)

      search_result = Item.search_name_descript('useful')

      expect(search_result).to be_an(Array) #fix this, current class Item::ActiveRecord_Relation
      expect(search_result.length).to eq(3)
      expect(search_result).not_to include(item_4)
    end

    it 'returns an empty array if no matches found' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      expect(Item.search_name_descript('useful')).to be_an(Array)
      expect(Item.search_name_descript('useful')).to be_empty
    end
  end

  describe 'search_price' do
    it 'returns list of matching items with both price params present' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      item_1 = create(:item, unit_price: 26.00, merchant: merchant_1)
      item_2 = create(:item, unit_price: 100.00, description: 100.00, merchant: merchant_1)
      item_3 = create(:item, unit_price: 47.98, merchant: merchant_2)
      # should not show up
      item_4 = create(:item, unit_price: 24.00, merchant: merchant_2)

      params = { min_price: 25.00, max_price: 101.00 }
      search_result = Item.search_price(params)

      expect(search_result).to be_an(Array)
      expect(search_result.length).to eq(3)
      expect(search_result).not_to include(item_4)
    end

    it 'returns list of higher priced items when only min_price is present' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      item_1 = create(:item, unit_price: 26.00, merchant: merchant_1)
      item_2 = create(:item, unit_price: 100.00, description: 100.00, merchant: merchant_1)
      item_3 = create(:item, unit_price: 47.98, merchant: merchant_2)
      # should not show up
      item_4 = create(:item, unit_price: 24.00, merchant: merchant_2)

      params = { min_price: 25.00, max_price: nil }
      search_result = Item.search_price(params)

      expect(search_result).to be_an(Array)
      expect(search_result.length).to eq(3)
      expect(search_result).not_to include(item_4)
    end

    it 'returns list of lower priced items when only max_price is present' do
      merchant_1 = create(:merchant, name: 'Schroeder-Jerde')
      merchant_2 = create(:merchant, name: 'Klein, Rempel and Sons')

      item_1 = create(:item, unit_price: 26.00, merchant: merchant_1)
      item_2 = create(:item, unit_price: 100.00, description: 100.00, merchant: merchant_1)
      item_3 = create(:item, unit_price: 47.98, merchant: merchant_2)
      # should not show up
      item_4 = create(:item, unit_price: 110.00, merchant: merchant_2)

      params = { min_price: nil, max_price: 101.00 }
      search_result = Item.search_price(params)

      expect(search_result).to be_an(Array)
      expect(search_result.length).to eq(3)
      expect(search_result).not_to include(item_4)
    end
  end
end
