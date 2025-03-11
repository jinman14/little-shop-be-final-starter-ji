class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :discount, :merchant_id, :status

  attribute :usage_count, if: Proc.new { |data, params| params && params[:action] == 'show' } do |coupon|
    coupon.usage_count
  end
end

# attribute :usage_count, if: Proc.new { |coupon, params|
# params && params[:show] == 'true' }
# end
# attribute :item_count, if: Proc.new { |merchant, params|
# params && params[:count] == "true" }
