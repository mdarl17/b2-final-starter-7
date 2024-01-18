require "rails_helper" 

RSpec.describe "merchant coupon show page" do 
  before(:each) do 
    @m3 = Merchant.create!(name: "Merchant 3", status: 1)

    @m1_5AND5 = Coupon.create!(name: "$5 off an order of $10 or more", code: "M1_5AND5", amount: 5, discount_type: 0, status: 1, merchant_id: @m3.id)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @m1_5AND5.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @m1_5AND5.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @m1_5AND5.id)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, coupon_id: @m1_5AND5.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @m3.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @m3.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @m3.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @m3.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 10, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 2, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 12, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 0, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_3.id)
    @transaction5 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_2.id)
    @transaction6 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)
  end

  it "displays a coupon's name, code, percent/dollar off avalue, active/inactive status, and its useage count" do 
    visit merchant_coupon_path(@m3.id, @m1_5AND5.id)

    expect(page).to have_content("$5 off an order of $10 or more")
    expect(page).to have_content("Code: M1_5AND5")
    expect(page).to have_content("Discount: 5")
    expect(page).to have_content("Status: active")
    expect(page).to have_content("Coupon Usage Count: 3")
  end

  it "has a button to deactivate coupon statuses if they are currently active" do 
    visit merchant_coupon_path(@m3.id, @m1_5AND5.id)
    expect(page).to have_button("Toggle Activation")
    expect(page).to have_content("Status: active")

    click_button "Toggle Activation"

    expect(current_path).to eq(merchant_coupon_path(@m3.id, @m1_5AND5.id))
    expect(page).to have_content("Status: inactive")
  end
    
  it "will not allow any coupon connected with a pending invoice to be deactivated" do 
    visit merchant_coupon_path(@m3.id, @m1_5AND5.id)
    # update an invoice's status to pending to test 'pending invoices' sad path
    @invoice_3.update!(status: 1)
    
    click_button "Toggle Activation"

    expect(current_path).to eq(merchant_coupon_path(@m3.id, @m1_5AND5.id))
    expect(page).to have_content("This coupon has pending invoices and can not be deactivated until all pending invoices are closed.")
    expect(page).to have_content("Status: active")
  end


#   As a merchant 
# When I visit one of my active coupon's show pages
# I see a button to deactivate that coupon
# When I click that buttonx
# I'm taken back to the coupon show page 
# And I can see that its status is now listed as 'inactive'.

# * Sad Paths to consider: 
# 1. A coupon cannot be deactivated if there are any pending invoices with that coupon.

end