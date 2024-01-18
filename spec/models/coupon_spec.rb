require "rails_helper" 

RSpec.describe Coupon, type: :model do
  before(:each) do 
    @m1 = Merchant.create!(name: "Merchant 1")
    @m1_fosho = Coupon.create!(name: "40% off any orde...FO SHO!", code: "M1_FOSHO", amount: 40, discount_type: 1, status: "inactive", merchant_id: @m1.id)
    @m1_bogo = Coupon.create!(name: "Buy one item, get that same item free!", code: "M1_BOGO", amount: 50, discount_type: 1, status: "active", merchant_id: @m1.id)
    @m1_half = Coupon.create!(name: "50% off any item", code: "M1_HALF_OFF1", amount: 50, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_buy3 = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_BUY3_4FREE", amount: 25, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_fast50 = Coupon.create!(name: "Any orders of $50 or more get $10 off", code: "M1_FAST50", amount: 10, discount_type: 0, status: "active",merchant_id: @m1.id)
    @m1_quarter = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_QRT_OFF", amount: 25, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_fiver = Coupon.create!(name: "Five dollars off any order!", code: "M1_FIVER", amount: 5, discount_type: 0, status: "inactive",merchant_id: @m1.id)
    @m1_hamilton = Coupon.create!(name: "$10 off any order!", code: "M1_HAMILTON", amount: 10, discount_type: 0, status: "inactive",merchant_id: @m1.id)
  end

  describe "relationships" do 
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
    it { should belong_to :merchant }
  end

  describe "instance methods" do 
    describe "#pending_invoices?" do 
      it "returns true if there are pending invoices connected to a coupon, and false otherwise" do 
      end
    end
  end

  describe "class methods" do 
    describe "::by_status" do 
      it "will return only those coupons that have the same status as the one passed as an argument" do
        expect(Coupon.by_status("active")).to match_array([@m1_bogo, @m1_half, @m1_buy3, @m1_fast50, @m1_quarter])
        expect(Coupon.by_status("inactive")).to match_array([@m1_fosho, @m1_fiver, @m1_hamilton])
      end
    end
  end
end