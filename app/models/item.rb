# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  validates :name, :description, :unit_price, presence: true

  def self.search_name_descript(query_params)
    # order(:name).where('name ILIKE ?', "%#{query_params}%")
    where('name ILIKE ? or description ILIKE ?',
          "%#{query_params}%", "%#{query_params}%").to_a
  end

  def self.search_price(query_params)
    # assign hash keys - min and max
    min = query_params[:min_price]
    max = query_params[:max_price]
    # conditional
    # return an array
    if min && max  # both min_price and max_price can be sent
      where('unit_price >= ?', min).where('unit_price <= ?', max).to_a
    elsif min
      where('unit_price >= ?', min).to_a
    elsif max
      where('unit_price <= ?', max).to_a
    end
  end
end
