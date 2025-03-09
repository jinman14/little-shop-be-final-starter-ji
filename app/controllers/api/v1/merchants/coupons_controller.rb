class Api::V1::Merchants::CouponsController < ApplicationController
  # before_action :set_merchant

  def index
    merchant = Merchant.find(params[:merchant_id])
    puts "Merchant ID: #{merchant.id}"
    coupons = merchant.coupons
    puts "Coupons: #{coupons.inspect}"

    render json: CouponSerializer.new(coupons)
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])

    render json: CouponSerializer.new(coupon)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.build(coupon_params)

    if coupon.status == 'active' && @merchant.coupons.active.count >= 5
      render json: { errors: ["This merchant already has 5 active coupons. Deactivate an old coupon to add a new one."] }, status: :unprocessable_entity
    else 
      if coupon.save
        render json: CouponSerializer.new(coupon), status: :created
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])

    if coupon.status == 'active' && @merchant.coupons.active.count >= 5
      render json: { errors: ["This merchant already has 5 active coupons. Deactivate an old coupon to activate a different one."] }
    else
      if coupon.update(coupon_params)
        render json: CouponSerializer.new(coupon)
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private
  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount, :status)
  end
end