require "rails_helper" 

RSpec.describe "merchant coupons index", type: :feature do 
  before(:each) do 
    @m1 = Merchant.create!(name: "Merchant 1")
    @m2 = Merchant.create!(name: "Merchant 2")
    @m3 = Merchant.create!(name: "Merchant 3", status: 1)
    @m1_bogo = Coupon.create!(name: "Buy one item, get that same item free!", code: "M1_BOGO", amount: 50, percent: 1, merchant_id: @m1.id)
    @m1_half = Coupon.create!(name: "50% off any item", code: "M1_HALF_OFF1", amount: 50, percent: 1, merchant_id: @m1.id)
    @m1_buy3 = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_BUY3_4FREE", amount: 25, percent: 1, merchant_id: @m1.id)
    @m2_10 = Coupon.create!(name: "$10 off any item!", code: "M2_10OFF", amount: 10, percent: 0, merchant_id: @m2.id)
    @m3_2024 = Coupon.create!(name: "$24 off an order of $100 or more", code: "M3_24", amount: 24, percent: 0, merchant_id: @m3.id)
    @m3_blowout = Coupon.create!(name: "50% off entire order!", code: "M3_TOTAL50", amount: 50, percent: 1, merchant_id: @m3.id)
  end

  it "has a link to view all of a merchant's coupons" do 
    visit merchant_dashboard_index_path(@m1.id)

    expect(page).to have_link("View all merchant coupons") 
    click_link("View all merchant coupons")
    expect(current_path).to eq(merchant_coupons_path(@m1.id))

    @m1.coupons.each do |coupon| 
      expect(page).to have_link(coupon.name)
      expect(page).to have_content(coupon.amount)
    end
  end

  describe "creating a new coupon" do 
    it "has a link to create a new coupon that, when clicked, takes users to an `add new coupon form`" do 
      visit merchant_coupons_path(@m1.id)

      expect(page).to have_link("Create a new coupon")
      click_link("Create a new coupon")
      expect(current_path).to eq(new_merchant_coupon_path(@m1.id))
      
      # the form is filled in with a name, unique code, amount, and designation of dollar or percentage value for amount"
      fill_in(:name, with: "FOMO $40 off deal")
      fill_in(:code, with: "M1_FOMO40")
      fill_in(:amount, with: 40)
      check(:percent)

    # when I click the Submit button the user is taken back to the coupon index page and can see the new coupon listed 
      click_button "Submit" 
      expect(current_path).to eq(merchant_coupons_path(@m1.id))
      visit merchant_coupons_path(@m1.id)
      expect(page).to have_link("FOMO $40 off deal")
      expect(page).to have_content("Discount Amount: $40")
      click_link("FOMO $40 off deal")
      expect(current_path).to eq(merchant_coupon_path(@m1.id, @m1.coupons.last.id))
    end
  end

end 