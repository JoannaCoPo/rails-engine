# frozen_string_literal: true

require 'rails_helper'

describe 'Revenue requests', type: :request do
  describe 'happy path' do
    it 'returns the top  merchant by revenue ' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, merchant: merchant)
      invoice_item = create(:invoice_item, unit_price: 100.00, quantity: 10, item: item, invoice: invoice)
      transaction = create(:transaction, invoice: invoice)

      merchant_2 = create(:merchant)
      item_2 = create(:item, merchant: merchant_2)
      invoice_2 = create(:invoice, merchant: merchant_2)
      invoice_item_2 = create(:invoice_item, unit_price: 1000.00, quantity: 10, item: item_2, invoice: invoice_2)
      transaction_2 = create(:transaction, invoice: invoice_2)

      merchant_3 = create(:merchant)
      item_3 = create(:item, merchant: merchant_3)
      invoice_3 = create(:invoice, merchant: merchant_3)
      invoice_item_3 = create(:invoice_item, unit_price: 500.00, quantity: 10, item: item_3, invoice: invoice_3)
      transaction_3 = create(:transaction, invoice: invoice_3)

      query_amount = 2

      get "/api/v1/revenue/merchants?quantity=#{query_amount}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(query_amount)
      expect(merchants[:data][0][:attributes][:name]).to eq(merchant_2.name)
      expect(merchants[:data][0][:attributes]).to have_key(:revenue)
    end

    # it 'fetches the top 10 merchants by revenue' do
    #
    # end
    #
    #
    # it 'returns all 100 merchants if quantity is too big ' do
    #
    # end
  end

  describe 'sad paths/edge cases' do
    # xit 'returns an error of some sort if quantity value is blank' do
    #
    # end
    #
    # xit 'returns an error of some sort if quantity is a string'  do
    #
    # end
    #
    # xit 'returns an error if quantity param is missing'  do
    #
    # end
  end
end

# find a quantity of merchants sorted by descending revenue
# find a quantity of merchants sorted by descending item quantity sold
# total revenue for a given merchant
# find a quantity of items sorted by descending revenue
