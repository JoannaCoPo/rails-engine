class MerchantRevenueSerializer
  include JSONAPI::Serializer
  # set_id :merchant_id
  attributes :name, :revenue
end
