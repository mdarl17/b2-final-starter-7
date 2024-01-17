require "rails_helper" 

RSpec.describe "merchant coupons index" do 
  before(:each) do 
    @m1 = Merchant.create!(name: "Merchant 1")
    @m2 = Merchant.create!(name: "Merchant 2")
    @m3 = Merchant.create!(name: "Merchant 3", status: 1)
    @m1_bogo = Coupon.create!(name: "Buy 1 get 1", code: "M1_BOGO", percentage_discount: 25, merchant_id: @m1.id)
    @m1_half = Coupon.create!(name: "50% off ANY item", code: "M1_HALF_OFF1", percentage_discount: 50, merchant_id: @m1.id)
    @m1_buy3 = Coupon.create!(name: "Buy ANY 3 items, get the fourth free", code: "M1_BUY3_4FREE", percentage_discount: 25, merchant_id: @m1.id)
    @m2_10 = Coupon.create!(name: "10% off any item", code: "M2_10OFF", percentage_discount: 10, merchant_id: @m2.id)
    @m3_2024 = Coupon.create!(name: "24% off first 5 items (must buy)", code: "M3_24", percentage_discount: 24, merchant_id: @m3.id)
    @m3_blowout = Coupon.create!(name: "50% off entire order", code: "M3_TOTAL50", percentage_discount: 50, merchant_id: @m3.id)
  end

  it "has a link to view all of a merchant's coupons" do 
    visit merchant_dashboard_index_path(@m1.id)

    expect(page).to have_link("View all merchant coupons") 
    click_link("View all merchant coupons")
    expect(current_path).to eq(merchant_coupons_path(@m1.id))

    save_and_open_page
    @m1.coupons.each do |coupon| 
      expect(page).to have_link(coupon.name)
      expect(page).to have_content(coupon.percentage_discount)
    end
  end
end 