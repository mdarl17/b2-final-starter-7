# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke

# Coupon.destroy_all 
# Merchant.destroy_all

# @m1 = Merchant.create!(name: "Merchant 1")
# @m2 = Merchant.create!(name: "Merchant 2")
# @m3 = Merchant.create!(name: "Merchant 3", status: 1)
# @m1_bogo = Coupon.create!(name: "Buy one item, get that same item free!", code: "M1_BOGO", amount: 50, discount_type: 1, status: 1, merchant_id: @m1.id)
# @m1_half = Coupon.create!(name: "50% off any item", code: "M1_HALF_OFF1", amount: 50, discount_type: 1, status: 1,merchant_id: @m1.id)
# @m1_buy3 = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_BUY3_4FREE", amount: 25, discount_type: 1, status: 1,merchant_id: @m1.id)
# @m1_fast50 = Coupon.create!(name: "Any orders of $50 or more get $10 off", code: "M1_FAST50", amount: 10, discount_type: 0, status: 1,merchant_id: @m1.id)
# @m1_quarter = Coupon.create!(name: "Buy three items of any kind, get the fourth free!", code: "M1_QRT_OFF", amount: 25, discount_type: 1, status: 1,merchant_id: @m1.id)
# @m2_10 = Coupon.create!(name: "$10 off any item!", code: "M2_10OFF", amount: 10, discount_type: 0, status: 1,merchant_id: @m2.id)
# @m3_2024 = Coupon.create!(name: "$24 off an order of $100 or more", code: "M3_24", amount: 24, discount_type: 0, status: 1, merchant_id: @m3.id)
# @m3_blowout = Coupon.create!(name: "50% off entire order!", code: "M3_TOTAL50", amount: 50, discount_type: 1, status: 1, merchant_id: @m3.id)