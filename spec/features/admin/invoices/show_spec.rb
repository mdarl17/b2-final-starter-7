require "rails_helper"

describe "Admin Invoices Index Page" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")

    @m1_fosho = Coupon.create!(name: "40% off any orde...FO SHO!", code: "M1_FOSHO", amount: 40, discount_type: 1, status: "inactive", merchant_id: @m1.id)
    @m1_bogo = Coupon.create!(name: "Buy one item, get that same item free!", code: "M1_BOGO", amount: 50, discount_type: 1, status: "active", merchant_id: @m1.id)
    @m1_half = Coupon.create!(name: "50% off any item", code: "M1_HALF_OFF1", amount: 50, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_buy3 = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_BUY3_4FREE", amount: 25, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_fast50 = Coupon.create!(name: "Any orders of $50 or more get $10 off", code: "M1_FAST50", amount: 10, discount_type: 0, status: "active",merchant_id: @m1.id)
    @m1_quarter = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_QRT_OFF", amount: 25, discount_type: 1, status: "active",merchant_id: @m1.id)
    @m1_fiver = Coupon.create!(name: "Five dollars off any order!", code: "M1_FIVER", amount: 5, discount_type: 0, status: "inactive",merchant_id: @m1.id)
    @m1_hamilton = Coupon.create!(name: "$10 off any order!", code: "M1_HAMILTON", amount: 10, discount_type: 0, status: "inactive",merchant_id: @m1.id)
    
    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09")
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09")

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

    visit admin_invoice_path(@i1)
  end

  it "should display the id, status and created_at" do
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end

  it "should display the customers name and shipping address" do
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end

  it "should display all the items on the invoice" do
    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)

    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_2.quantity)

    expect(page).to have_content("$#{@ii_1.unit_price}")
    expect(page).to have_content("$#{@ii_2.unit_price}")

    expect(page).to have_content(@ii_1.status)
    expect(page).to have_content(@ii_2.status)

    expect(page).to_not have_content(@ii_3.quantity)
    expect(page).to_not have_content("$#{@ii_3.unit_price}")
    expect(page).to_not have_content(@ii_3.status)
  end

  it "should display the total revenue the invoice will generate" do
    expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")

    expect(page).to_not have_content(@i2.total_revenue)
  end

  it "should have status as a select field that updates the invoices status" do
    within("#status-update-#{@i1.id}") do
      select("cancelled", :from => "invoice[status]")
      expect(page).to have_button("Update Invoice")
      click_button "Update Invoice"

      expect(current_path).to eq(admin_invoice_path(@i1))
      expect(@i1.status).to eq("completed")
    end
  end

end
