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
    if merchant.five_active_coupons?
      flash[:alert] = "Merchants may have only five active coupons. Please de-activate a coupon from this merchant before trying to create another one."
    elsif coupon.save
      merchant.coupons << coupon 
    else
      flash[:alert] = "There was a problem creating this coupon. Please try again later."
    end
    redirect_to merchant_coupons_path(merchant.id)
  end

  private

  def coupon_params
    params.permit(:name, :code, :amount, :percent?, :merchant_id)
  end
end