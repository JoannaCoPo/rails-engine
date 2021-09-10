# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  validates :name, :description, :unit_price, presence: true

  def self.search_name_descript(query_params)
    where('name ILIKE ? or description ILIKE ?',
          "%#{query_params}%", "%#{query_params}%").to_a
  end

  def self.search_price(query_params)
    min = query_params[:min_price]
    max = query_params[:max_price]
    if min && max
      where('unit_price >= ?', min).where('unit_price <= ?', max).to_a
    elsif min
      where('unit_price >= ?', min).to_a
    elsif max
      where('unit_price <= ?', max).to_a
    end
  end
end
