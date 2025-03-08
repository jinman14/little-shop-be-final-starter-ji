class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :discount, :merchant_id, :status
end
