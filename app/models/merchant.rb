# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices
  has_many :invoice_items, through: :items
  # has_many :transactions, through: :invoice_items

  def self.search_merchant_with_query(query)
    order(:name).where('name ILIKE ?', "%#{query}%").first
  end

# revenue = Number of units sold * average price.

  def self.top_revenue(query)
    # joins table invoice items or invoice?
    # access transactions for successful transaction and shipped status
    # organize by merchant id
    # grab all merch and set revenue as quanity * unit_price?
    # order descending
    # do i want to limit this?
    joins(invoice_items: {invoice: :transactions})
    .where("transactions.result = 'success' AND invoices.status = 'shipped'")
    .group("merchants.id")
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .order("revenue DESC")
    .limit(query)
  end
end

# HINT: Invoices must have a successful transaction and be shipped to the customer to be considered as revenue.

# ILIKE
# Allows matching of strings based on comparison with a pattern but is
# case-insensitive.

# <subject> ILIKE <pattern> [ ESCAPE <escape> ]
#
# ILIKE( <subject> , <pattern> [ , <escape> ] )
