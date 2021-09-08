# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  validates :name, :description, :unit_price, presence: true

  def self.search_with_query(query) #does this need to be alphabetical
    # order(:name).where('name ILIKE ?', "%#{query}%")
    where('name ILIKE ?', "%#{query}%")
  end
end
