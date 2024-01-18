class CouponsController < ApplicationController 
  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def show 
    @merchant = Merchant.find(coupon_params[:merchant_id])
    @coupon = @merchant.coupons.find_by(coupon_params[:code])
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
    end
    redirect_to merchant_coupons_path(merchant.id)
  end

  def update 
    @merchant = Merchant.find(coupon_params[:merchant_id])
    @coupon = @merchant.coupons.find(coupon_params[:id])

    if params[:act_deact_button] == "clicked"
      if @coupon.status == "active"
        if @coupon.pending_invoices?
          flash[:alert] = "This coupon has pending invoices and can not be deactivated until all pending invoices are closed."
        elsif @coupon.update(status: "inactive")
          flash[:message] = "#{@coupon.code} has been deactivated"
        end
      end
    end
    render :show, locals: coupon_params
  end

  private
  
  def coupon_params
    params.permit(:name, :code, :amount, :discount_type, :merchant_id, :id)
  end
  
end