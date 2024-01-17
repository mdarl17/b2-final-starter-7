class Coupon < ApplicationRecord 
  belongs_to :merchant
  has_many :invoices
  # has_many :invoice_items, through: :invoices

  enum percent: { "unchecked": 0, "checked": 1 }
  enum active: { "inactive": 0, "active": 1 }

  def usage_count
    self.invoices.select("coupons.id, COUNT(invoices.id) AS coupon_count")
      .joins(:coupon, :transactions, :invoice_items)
      .where("transactions.result > 0 AND coupons.id = ?", self.id)
      .group("coupons.id, invoices.id")
      .having("SUM(invoice_items.unit_price * invoice_items.quantity) >= 10")
      .length
  end
end