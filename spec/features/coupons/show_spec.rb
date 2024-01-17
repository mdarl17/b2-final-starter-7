require "rails_helper" 

RSpec.describe "merchant coupon show page" do 
  before(:each) do 
    @m3 = Merchant.create!(name: "Merchant 3", status: 1)
    @m3_2024 = Coupon.create!(name: "$24 off an order of $100 or more", code: "M3_24", amount: 24, percent: 0, merchant_id: @m3.id)
  end

  it "displays a coupon's name, code, percent/dollar off avalue, active/inactive status, and its useage count" do 
    # visit merchant_coupon_path(@m3.id, @)
  end
end 