class AddCouponForeignKeyToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoices, :coupon, foreign_key: true, null: true
  end
end
