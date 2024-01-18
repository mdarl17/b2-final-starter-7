require "rails_helper" 

RSpec.describe "merchant coupons index", type: :feature do 
  before(:each) do 
    @m1 = Merchant.create!(name: "Merchant 1")
    @m2 = Merchant.create!(name: "Merchant 2")
    @m3 = Merchant.create!(name: "Merchant 3", status: 1)
    @m1_fosho = Coupon.create!(name: "40% off any orde...FO SHO!", code: "M1_FOSHO", amount: 40, discount_type: 1, status: "inactive", merchant_id: @m1.id)
    @m1_bogo = Coupon.create!(name: "Buy one item, get that same item free!", code: "M1_BOGO", amount: 50, discount_type: 1, status: "active", merchant_id: @m1.id)
    @m1_half = Coupon.create!(name: "50% off any item", code: "M1_HALF_OFF1", amount: 50, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_buy3 = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_BUY3_4FREE", amount: 25, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_fast50 = Coupon.create!(name: "Any orders of $50 or more get $10 off", code: "M1_FAST50", amount: 10, discount_type: 0, status: "active",merchant_id: @m1.id)
    @m1_quarter = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_QRT_OFF", amount: 25, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_fiver = Coupon.create!(name: "Five dollars off any order!", code: "M1_FIVER", amount: 5, discount_type: 0, status: "inactive",merchant_id: @m1.id)
    @m1_hamilton = Coupon.create!(name: "$10 off any order!", code: "M1_HAMILTON", amount: 10, discount_type: 0, status: "inactive",merchant_id: @m1.id)
    @m2_10 = Coupon.create!(name: "$10 off any item!", code: "M2_10OFF", amount: 10, discount_type: 0, status: "inactive",merchant_id: @m2.id)
    @m3_2024 = Coupon.create!(name: "$24 off an order of $100 or more", code: "M3_24", amount: 24, discount_type: 0, status: "inactive", merchant_id: @m3.id)
    @m3_blowout = Coupon.create!(name: "50% off entire order!", code: "M3_TOTAL50", amount: 50, discount_type: 1, status: "active", merchant_id: @m3.id)
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
      check(:status)
      check(:percent)

    # when I click the Submit button the user is taken back to the coupon index page and can see the new coupon listed 
    # this coupon addition will not happen and trigger a flash message that there are already five active coupons
    # and that one needs to be made inactive to add it to the system.
      click_button "Submit"
  
      expect(current_path).to eq(merchant_coupons_path(@m1.id))
      expect(page).to have_content("Merchants may have only five active coupons. Please de-activate a coupon from this merchant before trying to create another one.")
      expect(page).to_not have_link("FOMO $40 off deal")
      expect(page).to_not have_content("Discount Amount: $40")

      # de-activate the merchant's first coupon in the list (giving them 4 total 'active' coupons)

      @m1.coupons.first.update!(status: "inactive")

      click_link("Create a new coupon")

      fill_in(:name, with: "FOMO $40 off deal")
      fill_in(:code, with: "M1_FOMO40")
      fill_in(:amount, with: 40)
      check(:status)
      check(:percent)

      click_button "Submit"

      # new coupon saves since, now, it no longer breaks the `5 active coupons/merchant` threshold
      expect(current_path).to eq(merchant_coupons_path(@m1.id))
      visit merchant_coupons_path(@m1.id)
      expect(page).to have_link("FOMO $40 off deal")
      expect(page).to have_content("Discount Amount: $40")
      click_link("FOMO $40 off deal")
      expect(current_path).to eq(merchant_coupon_path(@m1.id, @m1.coupons.last.id))
    end
  end

  it "separates the coupons in two sections - activated and inactivated coupons" do 
    visit merchant_coupons_path(@m1.id)

    within ".active-coupons" do 
      expect(page).to have_link(@m1_bogo.name)
      expect(page).to have_content(@m1_bogo.amount)
      expect(page).to have_link(@m1_half.name)
      expect(page).to have_content(@m1_half.amount)
      expect(page).to have_link(@m1_buy3.name)
      expect(page).to have_content(@m1_buy3.amount)
      expect(page).to have_link(@m1_fast50.name)
      expect(page).to have_content(@m1_fast50.amount)
      expect(page).to have_link(@m1_quarter.name)
      expect(page).to have_content(@m1_quarter.amount)

      expect(page).to_not have_link(@m1_fosho.name)
      expect(page).to_not have_link(@m1_fiver.name)
      expect(page).to_not have_link(@m1_hamilton.name)
    end

    within ".inactive-coupons" do 
      expect(page).to have_link(@m1_fosho.name)
      expect(page).to have_content(@m1_fosho.amount)
      expect(page).to have_link(@m1_fiver.name)
      expect(page).to have_content(@m1_fiver.amount)
      expect(page).to have_link(@m1_hamilton.name)
      expect(page).to have_content(@m1_hamilton.amount)

      expect(page).to_not have_link(@m1_bogo.name)
      expect(page).to_not have_link(@m1_half.name)
      expect(page).to_not have_link(@m1_buy3.name)
      expect(page).to_not have_link(@m1_fast50.name)
      expect(page).to_not have_link(@m1_quarter.name)
    end
  end
end 