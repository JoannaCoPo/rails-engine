# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices

  def self.search_merchant_with_query(query)
    where('name ILIKE ?', "%#{query}%")
  end
end

# ILIKE
# Allows matching of strings based on comparison with a pattern but is
# case-insensitive.

# <subject> ILIKE <pattern> [ ESCAPE <escape> ]
#
# ILIKE( <subject> , <pattern> [ , <escape> ] )
