class Coupon < ApplicationRecord 
  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices

  enum discount_type: { "dollar": 0, "percent": 1 }
  enum active: { "inactive": 0, "active": 1 }

  def usage_count
    self.transactions
      .where("transactions.result > 0")
      .count
  end
end