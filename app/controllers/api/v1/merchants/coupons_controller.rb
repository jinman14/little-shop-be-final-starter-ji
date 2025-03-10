class Api::V1::Merchants::CouponsController < ApplicationController
  before_action :set_merchant

  def index
    # coupons = @merchant.coupons
    
    # if params[:status]
    #   activity = params[:status]
    #   coupons = @merchant.coupons.coupon_activity_by_merchant(@merchant, activity)
    # end
    coupons = Coupon.coupon_activity_by_merchant(@merchant, params[:status])
    
    render json: CouponSerializer.new(coupons)
  end

  def show
    coupon = @merchant.coupons.find(params[:id])

    render json: CouponSerializer.new(coupon, params: { action: 'show' })
  end

  def create
    coupon = @merchant.coupons.build(coupon_params)

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
    coupon = @merchant.coupons.find(params[:id])

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