class Api::V1::CouponsController < ApplicationController
  
  def index
    coupons = Coupon.all

    render json: CouponSerializer.new(coupons)
  end

  def show
    coupons = Coupon.find(params[:id])

    render json: CouponSerializer.new(coupons)
  end

  def create
    coupon = Coupon.create!(coupon_params) 
    render json: CouponSerializer.new(coupon), status: :created
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update!(coupon_params)

    render json: CouponSerializer.new(coupon)
  end

  private

  def coupon_params
    params.permit(:name, :code, :discount, :merchant_id, :status)
  end
end