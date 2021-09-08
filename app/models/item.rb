# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  validates :name, :description, :unit_price, presence: true

  def self.search_name_descript(query_params) #NAME OR DESCRIPTION
    # order(:name).where('name ILIKE ?', "%#{query_params}%")
    where('name ILIKE ? or description ILIKE ?', "%#{query_params}%", "%#{query_params}%")
  end

  def self.search_price(query_params)
    require "pry"; binding.pry
  end
end
