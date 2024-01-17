class CouponsController < ApplicationController 
  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def show 
    
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create 
    merchant = Merchant.find(params[:merchant_id])
    coupon = Coupon.new(coupon_params)
    
    if coupon.save
      merchant.coupons << coupon 
    else
      flash[:alert] = "There was a problem and the merchant coupon could not be saved."
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :amount, :percent?, :merchant_id)
  end
end